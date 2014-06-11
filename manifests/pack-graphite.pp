class graphite::pack-graphite {

     $packagesToBeInstalled = ["python-django-tagging", "python-twisted", "fontconfig", "python-simplejson", "python-devel.x86_64", "mod_wsgi.x86_64", "mod_python.x86_64", "python-sqlite2.x86_64", "bitmap.x86_64", "pycairo.x86_64", "python-zope-interface.x86_64", "python-simplejson.x86_64", "python-pip.noarch", "python-twisted-web.x86_64", "bitmap", "gcc-c++.x86_64", "make.x86_64", 

]



package { $packagesToBeInstalled:
      ensure => latest,
      provider => 'yum',  
   }


}
