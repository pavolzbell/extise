class Expric::Projects::DpLocdcC
  include Extric::Common
  include Expric::Shared

  def initialize
    @p = reuse_metric Expric::Sessions::DpLocdcC
  end

  def measure(user, project)
    t = { interactions: [attachment: :task] }
    r = user.sessions.left_joins(t).where(Extisimo::Task.table_name => { project_id: project.id }).distinct.to_a

    return unless r.any?

    v = r.map { |session| fetch_value via: @p, of: user, on: session }
    v = Daru::Vector[*v].mean

    { value: v }
  end
end
