{% set cover = config.cover.home %}
{% if page.cover %}
  {% set cover = page.cover %}
{% elseif is_archive() %}
  {% set cover = config.cover.archives %}
{% endif %}

<div class="site-top-wrapper" style="background-image:url({{ cover }})">
  {% if is_home() %}
      <div class="site-overview">
        <div class="site-author" itemprop="author" itemscope itemtype="http://schema.org/Person">
          {% if theme.avatar %}
            <img class="site-author-image" itemprop="image"
              src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
              alt="{{ theme.author }}" />
          {% endif %}
          <p class="site-author-name" itemprop="name">{{ theme.author }}</p>
        </div>

        {% if theme.site_state %}
          <nav class="site-state">
            {% if config.archive_dir != '/' and site.posts.length > 0 %}
              <div class="site-state-item site-state-posts">
                {% if theme.menu.archives %}
                  <a href="{{ url_for(theme.menu.archives).split('||')[0] | trim }}">
                {% else %}
                  <a href="{{ url_for(config.archive_dir) }}">
                {% endif %}
                  <span class="site-state-item-count">{{ site.posts.length }}</span>
                  <span class="site-state-item-name">{{ __('state.posts') }}</span>
                </a>
              </div>
            {% endif %}

            {% if site.categories.length > 0 %}
              {% set categoriesPageQuery = site.pages.find({type: 'categories'}, {lean: true}) %}
              {% set hasCategoriesPage = categoriesPageQuery.length > 0 %}
              <div class="site-state-item site-state-categories">
                {% if hasCategoriesPage %}<a href="{{ url_for(categoriesPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.categories.length }}</span>
                  <span class="site-state-item-name">{{ __('state.categories') }}</span>
                  {% if hasCategoriesPage %}</a>{% endif %}
              </div>
            {% endif %}

            {% if site.tags.length > 0 %}
              {% set tagsPageQuery = site.pages.find({type: 'tags'}, {lean: true}) %}
              {% set hasTagsPage = tagsPageQuery.length > 0 %}
              <div class="site-state-item site-state-tags">
                {% if hasTagsPage %}<a href="{{ url_for(tagsPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.tags.length }}</span>
                  <span class="site-state-item-name">{{ __('state.tags') }}</span>
                {% if hasTagsPage %}</a>{% endif %}
              </div>
            {% endif %}
          </nav>
        {% endif %}

        {% if theme.social %}
          <div class="links-of-author">
            {% for name, link in theme.social %}
              <span class="links-of-author-item">
                <a href="{{ link.split('||')[0] | trim }}" target="_blank" title="{{ name }}">
                  {% if theme.social_icons.enable %}
                    <i class="fa fa-fw fa-{{ link.split('||')[1] | trim | default('globe') }}"></i>{#
                    #}{% endif %}</a>
              </span>
            {% endfor %}
            <span class="links-of-author-item">
              <a href="" target="_blank" title="zhihu"><img src="/images/zhihu.png"></a>
            </span>
          </div>
        {% endif %}

      </div>
  {% endif %}

  {% if is_post() %}
    {% if not headlessPost %}
      <div class="post-header custom-post-header">
        {# Not to show title for quote posts that do not have a title #}
        {% if not (is_index and page.type === 'quote' and not page.title) %}
          <{% if theme.seo %}h2{% else %}h1{% endif %} class="post-title{% if post.direction && post.direction.toLowerCase() === 'rtl' %} rtl{% endif %}" itemprop="name headline">{{ page.title }}{#
        #}</{% if theme.seo %}h2{% else %}h1{% endif %}>
        {% endif %}

        <div class="post-meta">      
          {% if theme.avatar %}
            <span class="post-author"><img itemprop="image"
                src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
                alt="{{ theme.author }}" /></span>
          {% endif %}
          <span class="post-time">
            {% if theme.post_meta.created_at %}
              <span class="post-meta-item-icon">
                <i class="fa fa-clock-o"></i>
              </span>
              {% if theme.post_meta.item_text %}
                <span class="post-meta-item-text">{{ __('post.posted') }}</span>
              {% endif %}
              <time title="{{ __('post.created') }}" itemprop="dateCreated datePublished" datetime="{{ moment(page.date).format() }}">{#
              #}{{ date(page.date, config.date_format) }}{#
            #}</time>
            {% endif %}

            {% if theme.post_meta.created_at and theme.post_meta.updated_at %}
              <span class="post-meta-divider">|</span>
            {% endif %}

            {% if theme.post_meta.updated_at %}
              <span class="post-meta-item-icon">
                <i class="fa fa-calendar-check-o"></i>
              </span>
              {% if theme.post_meta.item_text %}
                <span class="post-meta-item-text">{{ __('page.modified') }}&#58;</span>
              {% endif %}
              <time title="{{ __('page.modified') }}" itemprop="dateModified" datetime="{{ moment(page.updated).format() }}">{#
              #}{{ date(page.updated, config.date_format) }}{#
            #}</time>
            {% endif %}
          </span>

          {% if page.categories and page.categories.length and theme.post_meta.categories %}
            <span class="post-category" >
            {% if theme.post_meta.created_at or theme.post_meta.updated_at %}
              <span class="post-meta-divider">|</span>
            {% endif %}
              <span class="post-meta-item-icon">
                <i class="fa fa-folder-o"></i>
              </span>
              {% if theme.post_meta.item_text %}
                <span class="post-meta-item-text">{{ __('post.in') }}</span>
              {% endif %}
              {% for cat in page.categories %}
                <span itemprop="about" itemscope itemtype="http://schema.org/Thing">
                  <a href="{{ url_for(cat.path) }}" itemprop="url" rel="index">
                    <span itemprop="name">{{ cat.name }}</span>
                  </a>
                </span>

                {% set cat_length = post.categories.length %}
                {% if cat_length > 1 and loop.index !== cat_length %}
                  {{ __('symbol.comma') }}
                {% endif %}
              {% endfor %}
            </span>
          {% endif %}

          {# LeanCould PageView #}
          {% if theme.leancloud_visitors.enable %}
             <span id="{{ url_for(post.path) }}" class="leancloud_visitors" data-flag-title="{{ page.title }}">
               <span class="post-meta-divider">|</span>
               <span class="post-meta-item-icon">
                 <i class="fa fa-eye"></i>
               </span>
               <span class="leancloud-visitors-count"></span>
               <span class="post-meta-item-text">次阅读</span>
             </span>
          {% endif %}

          {% if config.symbols_count_time.symbols or config.symbols_count_time.time %}
            <span class="post-wordcount">
              <span class="post-meta-divider">|</span>
              {% if config.symbols_count_time.symbols %}
                <span class="post-meta-item-icon">
                  <i class="fa fa-pencil"></i>
                </span>
                <span title="{{ __('post.wordcount') }}">{#
                #}{{ symbolsCount(page.content) }}{#
              #}</span><span class="post-meta-item-text">字</span>
              {% endif %}
            </span>
          {% endif %}

        </div>
      </div>
    {% endif %}
  {% endif %}

  {% if not is_home() %}
    {% if not is_post() %}
      <div class="custom-page-title">{{ page.title }}</div>
    {% endif %}
  {% endif %}

  {% if is_archive() %}
    <div class="custom-page-title">时间轴 · Archives</div>
  {% endif %}
</div>

<div class="site-nav-toggle">
  <button>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
  </button>
</div>


<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.algolia_search.enable || theme.tinysou_Key || theme.local_search.enable %}

  <div class="site-title"><a href="/">{{ config.title }}</a></div>

  <div class="site-overview site-overview-mobile">
        <div class="site-author" itemprop="author" itemscope itemtype="http://schema.org/Person">
          {% if theme.avatar %}
            <img class="site-author-image" itemprop="image"
              src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
              alt="{{ theme.author }}" />
          {% endif %}
          <p class="site-author-name" itemprop="name">{{ theme.author }}</p>
        </div>

        {% if theme.site_state %}
          <nav class="site-state">
            {% if config.archive_dir != '/' and site.posts.length > 0 %}
              <div class="site-state-item site-state-posts">
                {% if theme.menu.archives %}
                  <a href="{{ url_for(theme.menu.archives).split('||')[0] | trim }}">
                {% else %}
                  <a href="{{ url_for(config.archive_dir) }}">
                {% endif %}
                  <span class="site-state-item-count">{{ site.posts.length }}</span>
                  <span class="site-state-item-name">{{ __('state.posts') }}</span>
                </a>
              </div>
            {% endif %}

            {% if site.categories.length > 0 %}
              {% set categoriesPageQuery = site.pages.find({type: 'categories'}, {lean: true}) %}
              {% set hasCategoriesPage = categoriesPageQuery.length > 0 %}
              <div class="site-state-item site-state-categories">
                {% if hasCategoriesPage %}<a href="{{ url_for(categoriesPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.categories.length }}</span>
                  <span class="site-state-item-name">{{ __('state.categories') }}</span>
                  {% if hasCategoriesPage %}</a>{% endif %}
              </div>
            {% endif %}

            {% if site.tags.length > 0 %}
              {% set tagsPageQuery = site.pages.find({type: 'tags'}, {lean: true}) %}
              {% set hasTagsPage = tagsPageQuery.length > 0 %}
              <div class="site-state-item site-state-tags">
                {% if hasTagsPage %}<a href="{{ url_for(tagsPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.tags.length }}</span>
                  <span class="site-state-item-name">{{ __('state.tags') }}</span>
                {% if hasTagsPage %}</a>{% endif %}
              </div>
            {% endif %}
          </nav>
        {% endif %}

        {% if theme.social %}
          <div class="links-of-author">
            {% for name, link in theme.social %}
              <span class="links-of-author-item">
                <a href="{{ link.split('||')[0] | trim }}" target="_blank" title="{{ name }}">
                  {% if theme.social_icons.enable %}
                    <i class="fa fa-fw fa-{{ link.split('||')[1] | trim | default('globe') }}"></i>{#
                    #}{% endif %}</a>
              </span>
            {% endfor %}
            <span class="links-of-author-item">
              <a href="" target="_blank" title="zhihu"><img src="/images/zhihu.png"></a>
            </span>
          </div>
        {% endif %}

  </div>

  {% if theme.menu %}
    <ul id="menu" class="menu">
      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
        <li class="menu-item menu-item-{{ itemName | replace(' ', '-') }}">
          <a href="{{ url_for(path.split('||')[0]) | trim }}" rel="section">
            {% if theme.menu_settings.icons %}{#
            #}<i class="menu-item-icon fa fa-fw fa-{{ path.split('||')[1] | trim | default('question-circle') }}"></i>{#
          #}{% endif %}{#

          #}{% if theme.menu_settings.badges %}{#
            #}{% if name == 'archives' %}{#
              #}{{ __('menu.' + name) | replace('menu.', '') }}{#
              #}<span class="badge">{{ site.posts.length }}</span>
              {% elseif name == 'categories' %}{#
              #}{{ __('menu.' + name) | replace('menu.', '') }}{#
              #}<span class="badge">{{ site.categories.length }}</span>
              {% elseif name == 'tags' %}{#
              #}{{ __('menu.' + name) | replace('menu.', '') }}{#
              #}<span class="badge">{{ site.tags.length }}</span>
              {% else %}{#
              #}{{ __('menu.' + name) | replace('menu.', '') }}{#
            #}{% endif %}{#
          #}{% else %}{#
            #}{{ __('menu.' + name) | replace('menu.', '') }}{#
          #}{% endif %}{#

        #}</a>
        </li>
      {% endfor %}

      {% if hasSearch %}
        <li class="menu-item menu-item-search">
          {% if theme.swiftype_key %}
            <a href="javascript:;" class="st-search-show-outputs">
          {% elseif theme.local_search.enable || theme.algolia_search.enable %}
            <a href="javascript:;" class="popup-trigger">
          {% endif %}
            {% if theme.menu_settings.icons %}
              <i class="menu-item-icon fa fa-search fa-fw"></i>{#
          #}{% endif %}{#
          #}{{ __('menu.search') }}{#
        #}</a>
        </li>
      {% endif %}
    </ul>
  {% endif %}

  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}

  <div class="nav-dimmer">
    <div class="nav-close">X</div>
  </div>
</nav>
