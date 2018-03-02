" Vim syntax file
" Language:    HAproxy
" Maintainer:  Bruno Michel <brmichel@free.fr>
" Last Change: Mar 30, 2007
" Version:     0.3
" URL:         http://haproxy.1wt.eu/
" URL:         http://vim.sourceforge.net/scripts/script.php?script_id=1845

" It is suggested to add the following line to $HOME/.vimrc :
"    au BufRead,BufNewFile haproxy* set ft=haproxy

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

if version >= 600
	setlocal iskeyword=_,-,a-z,A-Z,48-57
else
	set iskeyword=_,-,a-z,A-Z,48-57
endif


" Escaped chars
syn match   hapEscape    +\\\(\\\| \|n\|r\|t\|#\|x\x\x\)+

" Comments
syn match   hapComment   /#.*$/ contains=hapTodo
syn keyword hapTodo      contained TODO FIXME XXX
syn case ignore

" Sections
syn match   hapSection   /^\s*\(global\|defaults\)/
syn match   hapSection   /^\s*\(listen\|frontend\|backend\|ruleset\)/         skipwhite nextgroup=hapSectLabel
syn match   hapSectLabel /\S\+/                                               skipwhite nextgroup=hapIp1 contained
syn match   hapIp1       /\(\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\)\?:\d\{1,5}/        nextgroup=hapIp2 contained
syn match   hapIp2       /,\(\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\)\?:\d\{1,5}/hs=s+1 nextgroup=hapIp2 contained

" Timeouts and such specified in ms
syn match   hapNumberMS  /\d\+ms/ contained
" Timeouts generally specified in whole seconds
syn match   hapNumberSec /\d\+s/ contained
" Other numbers, no 'ms'.
syn match   hapNumber    /[0-9]\+/ contained

" Timeout types
syn keyword hapTimeoutType connect client server skipwhite nextgroup=hapNumberMS contained

" URIs
syn match hapAbsURI   /\/\S*/ contained
syn match hapURI      /\S*/ contained

" File paths (always absolute, and never just '/' unless you're insane)
syn match hapFilePath /\/\S\+/ contained

" SSL configuration keywords
syn match hapSSLCiphers  /\([-+!]\?[A-Z0-9-]\+[:+]\)*[-+!]\?[A-Z0-9-]\+/ contained

"
" ACLs
"

" This comes first, lest it gobble up everything else.
syn match hapAclName               /\S\+/               contained skipwhite nextgroup=hapAclCriterion
syn match hapAclCriterion          /FALSE\|HTTP\|HTTP_1\.0\|HTTP_1\.1\|HTTP_CONTENT\|HTTP_URL_ABS\|HTTP_URL_SLASH\|HTTP_URL_STAR\|LOCALHOST\|METH_CONNECT\|METH_GET\|METH_HEAD\|METH_OPTIONS\|METH_POST\|METH_TRACE\|RDP_COOKIE\|REQ_CONTENT\|TRUE\|WAIT_END\|\(req_rdp_cookie\|s\?cook\|s\?hdr\|http_auth_group\|urlp\)\(_\(beg\|dir\|dom\|end\|len\|reg\|sub\|cnt\)\)\?([^)]*)\|\(req_ssl_[a-z]\+\|base\|method\|path\|req_ver\|resp_ver\|url\)\(_\(beg\|dir\|dom\|end\|len\|reg\|sub\|cnt\)\)\?/ contained skipwhite nextgroup=hapAclConverterOrNothing
" This one's a bit tricky.  Match zero or more converters, and then *require* the
" space afterwards.  Strictly speaking, deviates from the BNF, but only in
" pathological cases ('acl lolwat TRUE,upper').
syn match hapAclConverterOrNothing /\(,\(\(base64\|bool\|cpl\|debug\|even\|hex\|lower\|neg\|not\|odd\|upper\|url_dec\)\|\(add\|and\|bytes\|crc32\|da-csv-conv\|div\|djb2\|field\|http_date\|in_table\|ipmask\|json\|language\|ltime\|map\|mod\|mul\|or\|regsub\|capture-req\|capture-res\|sdbm\|sub\|table_[a-z0-9_]\+\|utime\|word\|wt6\|xor\)([^)]*)\)\)*\s\+/ contained nextgroup=hapAclFlag,hapAclFlagWithParameter,hapAclOperator
syn match hapAclFlag               /-[-in]/             contained skipwhite nextgroup=hapAclFlag,hapAclFlagWithParameter,hapAclOperator
syn match hapAclFlagWithParameter  /-[fmMu]/            contained skipwhite nextgroup=hapAclFlagParameter
syn match hapAclFlagParameter      /\S\+/               contained skipwhite nextgroup=hapAclFlag,hapAclFlagWithParameter,hapAclOperator
syn match hapAclOperator           /eq\|ge\|gt\|le\|lt/ contained skipwhite


" Generic tune.ssl
syn match hapParam     /tune.ssl.[a-z0-9-]\+/
" tune.ssl where we know what follows
syn match hapParam     /tune\.ssl\.default-dh-param/ skipwhite nextgroup=hapNumber

" Parameters
syn keyword hapParam     timeout                  skipwhite nextgroup=hapTimeoutType
syn keyword hapParam     chroot pidfile           skipwhite nextgroup=hapFilePath
syn keyword hapParam     cliexp clitimeout contimeout
syn keyword hapParam     daemon debug disabled
syn keyword hapParam     enabled
syn keyword hapParam     fullconn maxconn         skipwhite nextgroup=hapNumber
syn keyword hapParam     gid grace group
syn keyword hapParam     monitor-uri
syn keyword hapParam     nbproc noepoll nopoll
syn keyword hapParam     quiet
syn keyword hapParam     redispatch retries       skipwhite nextgroup=hapNumber
syn match hapParam       /reqi\?\(allow\|del\|deny\|pass\|tarpit\)/ skipwhite nextgroup=hapRegexp
syn match hapParam       /rspi\?\(del\|deny\)/    skipwhite nextgroup=hapRegexp
syn keyword hapParam     reqsetbe reqisetbe       skipwhite nextgroup=hapRegexp2
syn keyword hapParam     reqadd reqiadd rspadd rspiadd
syn keyword hapParam     server source srvexp srvtimeout
syn keyword hapParam     uid ulimit-n user
syn keyword hapParam     acl                      skipwhite nextgroup=hapAclName
syn keyword hapParam     reqrep reqirep rsprep rspirep    skipwhite nextgroup=hapRegexp
syn keyword hapParam     errorloc errorloc302 errorloc303 skipwhite nextgroup=hapStatusURI
syn keyword hapParam     default_backend use_backend      skipwhite nextgroup=hapSectLabel
syn keyword hapParam     appsession               skipwhite nextgroup=hapAppSess
syn keyword hapParam     bind                     skipwhite nextgroup=hapIp1
syn keyword hapParam     balance                  skipwhite nextgroup=hapBalance
syn keyword hapParam     cookie                   skipwhite nextgroup=hapCookieNam
syn keyword hapParam     capture                  skipwhite nextgroup=hapCapture
syn keyword hapParam     dispatch                 skipwhite nextgroup=hapIpPort
syn keyword hapParam     source                   skipwhite nextgroup=hapIpPort
syn keyword hapParam     mode                     skipwhite nextgroup=hapMode
syn keyword hapParam     monitor-net              skipwhite nextgroup=hapIPv4Mask
syn keyword hapParam     option                   skipwhite nextgroup=hapOption
syn keyword hapParam     stats                    skipwhite nextgroup=hapStats
syn keyword hapParam     server                   skipwhite nextgroup=hapServerN
syn keyword hapParam     source                   skipwhite nextgroup=hapServerEOL
syn keyword hapParam     log                      skipwhite nextgroup=hapGLog,hapLogIp,hapFilePath
syn keyword hapParam     ca-base                  skipwhite nextgroup=hapFilePath
syn keyword hapParam     crt-base                 skipwhite nextgroup=hapFilePath
syn keyword hapParam     ssl-default-bind-ciphers skipwhite nextgroup=hapSSLCiphers
syn keyword hapParam     ssl-default-bind-options skipwhite nextgroup=hapGLog,hapLogIp
syn keyword hapParam     errorfile                skipwhite nextgroup=hapStatusPath
syn keyword hapParam     http-request
syn keyword hapParam     redirect

" Options and additional parameters
syn keyword hapAppSess   contained len timeout
syn keyword hapBalance   contained roundrobin source
syn keyword hapLen       contained len
syn keyword hapGLog      contained global
syn keyword hapMode      contained http tcp health
syn keyword hapOption    contained abortonclose allbackups checkcache clitcpka dontlognull forceclose forwardfor http-server-close
syn keyword hapOption    contained httpchk httpclose httplog keepalive logasap persist srvtcpka ssl-hello-chk
syn keyword hapOption    contained tcplog tcpka tcpsplice
syn keyword hapOption    contained except skipwhite nextgroup=hapIPv4Mask
syn keyword hapStats     contained realm auth scope enable
syn keyword hapStats     contained uri skipwhite nextgroup=hapAbsURI
syn keyword hapStats     contained socket skipwhite nextgroup=hapFilePath
syn keyword hapStats     contained timeout skipwhite nextgroup=hapNumberSec
syn keyword hapLogFac    contained kern user mail daemon auth syslog lpr news nextgroup=hapLogLvl skipwhite
syn keyword hapLogFac    contained uucp cron auth2 ftp ntp audit alert cron2  nextgroup=hapLogLvl skipwhite
syn keyword hapLogFac    contained local0 local1 local2 local3 local4 local5 local6 local7 nextgroup=hapLogLvl skipwhite
syn keyword hapLogLvl    contained emerg alert crit err warning notice info debug
syn keyword hapCookieKey contained rewrite insert nocache postonly indirect prefix nextgroup=hapCookieKey skipwhite
syn keyword hapCapture   contained cookie nextgroup=hapNameLen skipwhite
syn keyword hapCapture   contained request response nextgroup=hapHeader skipwhite
syn keyword hapHeader    contained header nextgroup=hapNameLen skipwhite
syn keyword hapSrvKey    contained backup cookie check inter rise fall port source minconn maxconn weight usesrc
syn match   hapStatus    contained /\d\{3}/
syn match   hapStatusPath contained /\d\{3}/ skipwhite nextgroup=hapFilePath
syn match   hapStatusURI contained /\d\{3}/ skipwhite nextgroup=hapURI
syn match   hapIPv4Mask  contained /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\(\/\d\{1,2}\)\?/
syn match   hapLogIp     contained /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}/   nextgroup=hapLogFac skipwhite
syn match   hapIpPort    contained /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}:\d\{1,5}/
syn match   hapServerAd  contained /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\(:[+-]\?\d\{1,5}\)\?/ nextgroup=hapSrvEOL skipwhite
syn match   hapNameLen   contained /\S\+/ nextgroup=hapLen       skipwhite
syn match   hapCookieNam contained /\S\+/ nextgroup=hapCookieKey skipwhite
syn match   hapServerN   contained /\S\+/ nextgroup=hapServerAd  skipwhite
syn region  hapSrvEOL    contained start=/\S/ end=/$/ contains=hapSrvKey
syn region  hapRegexp    contained start=/\S/ end=/\(\s\|$\)/ skip=/\\ / nextgroup=hapRegRepl skipwhite
syn region  hapRegRepl   contained start=/\S/ end=/$/ contains=hapComment,hapEscape,hapBackRef
syn region  hapRegexp2   contained start=/\S/ end=/\(\s\|$\)/ skip=/\\ / nextgroup=hapSectLabel skipwhite
syn match   hapBackref   contained /\\\d/


" Transparent is a Vim keyword, so we need a regexp to match it
syn match   hapParam     +transparent+
syn match   hapOption    +transparent+ contained


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version < 508
	command -nargs=+ HiLink hi link <args>
else
	command -nargs=+ HiLink hi def link <args>
endif

HiLink      hapEscape    SpecialChar
HiLink      hapBackRef   Special
HiLink      hapComment   Comment
HiLink      hapTodo      Todo
HiLink      hapSection   Underlined
HiLink      hapSectLabel Identifier
HiLink      hapParam     Keyword
HiLink      hapSSLCiphers String " Tried this as hapParam, but it's way too loud.
HiLink      hapTimeoutType hapParam

HiLink      hapRegexp    String
HiLink      hapRegexp2   hapRegexp
HiLink      hapFilePath  String
HiLink      hapURI       String
HiLink      hapAbsURI    hapURI
HiLink      hapIp1       Number
HiLink      hapIp2       hapIp1
HiLink      hapLogIp     hapIp1
HiLink      hapIpPort    hapIp1
HiLink      hapIPv4Mask  hapIp1
HiLink      hapServerAd  hapIp1
HiLink      hapStatus    Number
HiLink      hapStatusPath hapStatus
HiLink      hapStatusURI hapStatus
HiLink      hapNumber    Number
HiLink      hapNumberMS  Number
HiLink      hapNumberSec Number

HiLink      hapAclName               Identifier
HiLink      hapAclCriterion          String
HiLink      hapAclConverterOrNothing Special
HiLink      hapAclFlag               Special
HiLink      hapAclFlagWithParameter  Special
HiLink      hapAclFlagParameter      String
HiLink      hapAclOperator           Operator
HiLink      hapAclPattern            String

HiLink      hapOption    Operator
HiLink      hapAppSess   hapOption
HiLink      hapBalance   hapOption
HiLink      hapCapture   hapOption
HiLink      hapCookieKey hapOption
HiLink      hapHeader    hapOption
HiLink      hapGLog      hapOption
HiLink      hapLogFac    hapOption
HiLink      hapLogLvl    hapOption
HiLink      hapMode      hapOption
HiLink      hapStats     hapOption
HiLink      hapLen       hapOption
HiLink      hapSrvKey    hapOption


delcommand HiLink

let b:current_syntax = "haproxy"
" vim: ts=8
