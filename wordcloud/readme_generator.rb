require_relative "./cloud_types"

class ReadmeGenerator
  WORD_CLOUD_URL = 'https://raw.githubusercontent.com/Prachiofficial/Prachiofficial/master/wordcloud/wordcloud.png'
  ADDWORD = 'add'
  SHUFFLECLOUD = 'shuffle'
  INITIAL_COUNT = 3
  USER = "Prachiofficial"

  def initialize(octokit:)
    @octokit = octokit
  end

  def generate
    participants = Hash.new(0)
    current_contributors = Hash.new(0)
    current_words_added = INITIAL_COUNT
    total_clouds = CloudTypes::CLOUDLABELS.length
    total_words_added = INITIAL_COUNT * total_clouds

    octokit.issues.each do |issue|
      participants[issue.user.login] += 1
      if issue.title.split('|')[1] != SHUFFLECLOUD && issue.labels.any? { |label| CloudTypes::CLOUDLABELS.include?(label.name) }
        total_words_added += 1
        if issue.labels.any? { |label| label.name == CloudTypes::CLOUDLABELS.last }
          current_words_added += 1
          current_contributors[issue.user.login] += 1
        end
      end
    end

    markdown = <<~HTML
    <img src="https://github.com/HarshitKumar9030/HarshitKumar9030/blob/main/github.png">

    # Hi there I am [Prachi 🖐️][website]
    <br />
    
    ## I am a developer and a student.
    
    - 👋 Hi, I’m Prachi Arya
    - 👀 I’m interested in Playing Guitar, Linux and Javascript ...
    - 🌱 I’m currently learning React .
    - 📫 Mail me at Prachi@prachiarya.me
    
    <br />

    ## Github Info / Stats
  <div>
    <a align="left" href="#"><img alt="Prachi's Github Stats" src="https://github-readme-stats.vercel.app/api?username=Prachiofficial&show_icons=true&include_all_commits=true&count_private=true&theme=react&hide_border=true&bg_color=0D1117&title_color=5ce1e6&icon_color=5ce1e6" height="200"/></a>
    <a align="right" href="#"><img alt="Prachiofficial's Top Languages" src="https://github-readme-stats.vercel.app/api/top-langs/?username=Prachiofficial&langs_count=10&layout=compact&theme=react&hide_border=true&bg_color=0D1117&title_color=5ce1e6&icon_color=5ce1e6" height="200"/></a>
   <p align="center"> <img src="https://komarev.com/ghpvc/?username=Prachiofficial-1nc0re&label=Profile%20views&color=0e75b6&style=flat" alt="Prachiofficial" /> </p>
    <br/>
    <i><b>Note:</b> Top languages is only a metric of the languages my public code consists of and doesn't reflect experience or skill level.</i>
  </div>

<br/>
<img src="https://raw.githubusercontent.com/halfrost/halfrost/master/icons/header_.png">

[website]: https://www.prachiarya.me

<br />
    
### :thought_balloon: [Add a word](https://github.com/Prachiofficial/Prachiofficial/issues/new?template=addword.md&title=wordcloud%7C#{ADDWORD}%7C%3CINSERT-WORD%3E) to see the word cloud update in real time :rocket:

A new word cloud will be automatically generated when you [add your own word](https://github.com/Prachiofficial/Prachiofficial/issues/new?template=addword.md&title=wordcloud%7C#{ADDWORD}%7C%3CINSERT-WORD%3E). The prompt will change frequently, so be sure to come back and check it out :relaxed:

:star2: Don't like the arrangement of the current word cloud? [Regenerate it](https://github.com/Prachiofficial/Prachiofficial/issues/new?template=shufflecloud.md&title=wordcloud%7C#{SHUFFLECLOUD}) :game_die:

<div align="center">

## #{CloudTypes::CLOUDPROMPTS.last}

<img src="#{WORD_CLOUD_URL}" alt="WordCloud" width="100%">

![Word Cloud Words Badge](https://img.shields.io/badge/Words%20in%20this%20Cloud-#{current_words_added}-informational?labelColor=7D898B)
![Word Cloud Contributors Badge](https://img.shields.io/badge/Contributors%20this%20Cloud-#{current_contributors.size}-blueviolet?labelColor=7D898B)

    HTML

    # TODO: [![Github Badge](https://img.shields.io/badge/-@username-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/username)](https://github.com/username)

    current_contributors.each do |username, count|
      markdown.concat("[![Github Badge](https://img.shields.io/badge/-@#{format_username(username)}-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/#{username})](https://github.com/#{username}) ")
    end

    markdown.concat("\n\n Check out the [previous word cloud](#{previous_cloud_url}) to see our community's **#{CloudTypes::CLOUDPROMPTS[-2]}**")
  end

  private

  def format_username(name)
    name.gsub('-', '--')
  end

  def previous_cloud_url
    url_end = CloudTypes::CLOUDPROMPTS[-2].gsub(' ', '-').gsub(':', '').gsub('?', '').downcase
    "https://github.com/Prachiofficial/Prachiofficial/blob/master/previous_clouds/previous_clouds.md##{url_end}"
  end

  attr_reader :octokit
end
