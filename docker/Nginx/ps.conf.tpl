upstream fastcgi_backend {
server php:9000; # Variables: FPM_HOST and FPM_PORT
}

server {
    set $PS_ROOT /var/www/html;

    listen 80;

    server_name $ENV{"NGINX_HOST"};

    root $PS_ROOT;
    index index.php index.html;
    charset UTF-8;
    client_max_body_size 100m;

    # Support for SSL termination.
        set $my_http "http";
        set $my_ssl "off";
        set $my_port "80";
        if ($http_x_forwarded_proto = "https") {
        set $my_http "https";
        set $my_ssl "on";
        set $my_port "443";
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    ## Adding Caching

    # cache.appcache, your document html and data
    location ~* \.(?:manifest|appcache|xml|json)$ {
       expires -1;
    }

    # Media: css, html, images & icons
    location ~* \.(?:css|html?|js|jpg|jpeg|gif|png|ico)$ {
      expires 12M;
      access_log off;
      add_header Cache-Control "public";
    }

    location ~ \.php$ {
        fastcgi_pass   fastcgi_backend;

        fastcgi_param  PHP_FLAG  "session.auto_start=off \n suhosin.session.cryptua=off";
        fastcgi_param  PHP_VALUE "memory_limit=768M \n max_execution_time=600";
        fastcgi_read_timeout 600s;
        fastcgi_connect_timeout 600s;

        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    # Rewrite rules for prestashop
    rewrite ^/api/?(.*)$ /webservice/dispatcher.php?url=$1 last;
    rewrite ^/([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$1$2$3.jpg last;
    rewrite ^/([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$1$2$3$4.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$1$2$3$4$5.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$1$2$3$4$5$6.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$1$2$3$4$5$6$7.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$1$2$3$4$5$6$7$8.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$7/$1$2$3$4$5$6$7$8$9.jpg last;
    rewrite ^/([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])(\-[_a-zA-Z0-9-]*)?(-[0-9]+)?/.+\.jpg$ /img/p/$1/$2/$3/$4/$5/$6/$7/$8/$1$2$3$4$5$6$7$8$9$10.jpg last;
    rewrite ^/c/([0-9]+)(\-[\.*_a-zA-Z0-9-]*)(-[0-9]+)?/.+\.jpg$ /img/c/$1$2$3.jpg last;
    rewrite ^/c/([a-zA-Z_-]+)(-[0-9]+)?/.+\.jpg$ /img/c/$1$2.jpg last;
    rewrite ^/images_ie/?([^/]+)\.(jpe?g|png|gif)$ /js/jquery/plugins/fancybox/images/$1.$2 last;

    gzip                on;
    gzip_min_length     10000;
    gzip_proxied        any;
}
