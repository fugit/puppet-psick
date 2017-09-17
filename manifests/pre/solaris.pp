# @summary Manages prerequisite classes on Solaris. They are applied before the others
#
# This class manages prerequisites resources for all the other classes.
# Basically package repositories, subscriptions and eventually proxy server to
# use.
# This psick class is the only one included by default on the base psicks.
#
# @param manage If to actually manage any resource. Set to false to disable
#   any effect of the pre psick.
# @param proxy_class Name of the class to include to the system's proxy server
# @param repo_class Name of the class to include to manage repos
#
# @example Including additional classes for rpmgpg and repo
#    psick::pre::solaris::proxy_class: '::psick::solaris::proxy'
#    psick::pre::solaris::repo_class: '::psick::solaris::repo'
#
class psick::pre::solaris (
  # General switch. If false nothing is done.
  Boolean $manage     = true,
  String $proxy_class = '',
  String $repo_class  = '',
) {

  if $proxy_class != '' and $manage {
    contain $proxy_class
  }

  if $repo_class != '' and $manage {
    contain $repo_class
  }

}