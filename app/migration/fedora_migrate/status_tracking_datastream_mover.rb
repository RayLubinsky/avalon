module FedoraMigrate
  class StatusTrackingDatastreamMover < DatastreamMover
    DIGEST_CLASS = Digest::SHA2
    
    def migrate
      ds_name = source.dsid
      source_class = source.digital_object.models.last.scan(/afmodel:(.+)$/).flatten.last rescue source.class.name
      status = MigrationStatus.create source_class: source_class, f3_pid: source.pid, f4_pid: target.id.split(/\//).first, datastream: ds_name
      begin
        super
        checksums = {
          source: generate_checksum { source.content },
          target: generate_checksum { target.content }
        }
        success = xml? ? EquivalentXml.equivalent?(source.content,target.content) : checksums[:source] == checksums[:target]
        status.update_attributes checksum: checksums[:target], status: success
      rescue Exception => e
        status.update_attributes status: false, log: e.message
      ensure
        status.save
      end
    end
    
    private
    def generate_checksum
      (DIGEST_CLASS.new << yield).hexdigest
    end
    
    def xml?
      !!(source.mimeType =~ %r{[/+]xml$})
    end
  end
end
