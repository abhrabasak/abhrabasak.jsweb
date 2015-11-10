module ViewHelper
  def build_social_contacts(contacts, classnames)
    partial 'layouts/components/social', locals: { contacts: contacts, classnames: classnames }
  end
  def build_graph(graphdata)
    partial 'layouts/components/graph', locals: { graphdata: graphdata }
  end
  def build_intro(introdata)
    partial 'layouts/components/intropane', locals: { intro: introdata }
  end
end
