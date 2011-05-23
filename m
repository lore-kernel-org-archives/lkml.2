Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1EWQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab1EWQRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:17:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110520111733.b5319a02.randy.dunlap@oracle.com>
References: <20110520111733.b5319a02.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dhowells@redhat.com, linux-doc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH for-next] Documentation: add Documentation/security/
Date: Mon, 23 May 2011 17:17:02 +0100
Message-ID: <31165.1306167422@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> added to
>   git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs.git  docs-move
> 
> 
> commit d410fa4ef99112386de5f218dd7df7b4fca910b4
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Thu May 19 15:59:38 2011 -0700
> 
>     Create Documentation/security/,
>     move LSM-, credentials-, and keys-related files from Documentation/
>       to Documentation/security/,
>     add Documentation/security/00-INDEX, and
>     update all occurrences of Documentation/<moved_file>
>       to Documentation/security/<moved_file>.
> 
> 
>  Documentation/00-INDEX                             |    6 ++----
>  Documentation/filesystems/nfs/idmapper.txt         |    4 ++--
>  Documentation/networking/dns_resolver.txt          |    4 ++--
>  Documentation/security/00-INDEX                    |   18 ++++++++++++++++++
>  Documentation/{ => security}/SELinux.txt           |    0
>  Documentation/{ => security}/Smack.txt             |    0
>  Documentation/{ => security}/apparmor.txt          |    0
>  Documentation/{ => security}/credentials.txt       |    2 +-
>  Documentation/{ => security}/keys-request-key.txt  |    4 ++--
>  .../{ => security}/keys-trusted-encrypted.txt      |    0
>  Documentation/{ => security}/keys.txt              |    4 ++--
>  Documentation/{ => security}/tomoyo.txt            |    0
>  MAINTAINERS                                        |    6 +++---
>  include/linux/cred.h                               |    2 +-
>  include/linux/key.h                                |    2 +-
>  kernel/cred.c                                      |    2 +-
>  scripts/selinux/README                             |    2 +-
>  security/apparmor/match.c                          |    2 +-
>  security/apparmor/policy_unpack.c                  |    4 ++--
>  security/keys/encrypted.c                          |    2 +-
>  security/keys/request_key.c                        |    2 +-
>  security/keys/request_key_auth.c                   |    2 +-
>  security/keys/trusted.c                            |    2 +-
>  23 files changed, 43 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/security/00-INDEX
>  rename Documentation/{ => security}/SELinux.txt (100%)
>  rename Documentation/{ => security}/Smack.txt (100%)
>  rename Documentation/{ => security}/apparmor.txt (100%)
>  rename Documentation/{ => security}/credentials.txt (99%)
>  rename Documentation/{ => security}/keys-request-key.txt (98%)
>  rename Documentation/{ => security}/keys-trusted-encrypted.txt (100%)
>  rename Documentation/{ => security}/keys.txt (99%)
>  rename Documentation/{ => security}/tomoyo.txt (100%)

Acked-by: David Howells <dhowells@redhat.com>
