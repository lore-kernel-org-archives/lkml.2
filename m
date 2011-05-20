Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab1ETSSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:18:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57578 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab1ETSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:17:59 -0400
Date: Fri, 20 May 2011 11:17:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        David Howells <dhowells@redhat.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH for-next] Documentation: add Documentation/security/
Message-Id: <20110520111733.b5319a02.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DD6B04C.01F9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added to
  git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs.git  docs-move


commit d410fa4ef99112386de5f218dd7df7b4fca910b4
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Thu May 19 15:59:38 2011 -0700

    Create Documentation/security/,
    move LSM-, credentials-, and keys-related files from Documentation/
      to Documentation/security/,
    add Documentation/security/00-INDEX, and
    update all occurrences of Documentation/<moved_file>
      to Documentation/security/<moved_file>.


 Documentation/00-INDEX                             |    6 ++----
 Documentation/filesystems/nfs/idmapper.txt         |    4 ++--
 Documentation/networking/dns_resolver.txt          |    4 ++--
 Documentation/security/00-INDEX                    |   18 ++++++++++++++++++
 Documentation/{ => security}/SELinux.txt           |    0
 Documentation/{ => security}/Smack.txt             |    0
 Documentation/{ => security}/apparmor.txt          |    0
 Documentation/{ => security}/credentials.txt       |    2 +-
 Documentation/{ => security}/keys-request-key.txt  |    4 ++--
 .../{ => security}/keys-trusted-encrypted.txt      |    0
 Documentation/{ => security}/keys.txt              |    4 ++--
 Documentation/{ => security}/tomoyo.txt            |    0
 MAINTAINERS                                        |    6 +++---
 include/linux/cred.h                               |    2 +-
 include/linux/key.h                                |    2 +-
 kernel/cred.c                                      |    2 +-
 scripts/selinux/README                             |    2 +-
 security/apparmor/match.c                          |    2 +-
 security/apparmor/policy_unpack.c                  |    4 ++--
 security/keys/encrypted.c                          |    2 +-
 security/keys/request_key.c                        |    2 +-
 security/keys/request_key_auth.c                   |    2 +-
 security/keys/trusted.c                            |    2 +-
 23 files changed, 43 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/security/00-INDEX
 rename Documentation/{ => security}/SELinux.txt (100%)
 rename Documentation/{ => security}/Smack.txt (100%)
 rename Documentation/{ => security}/apparmor.txt (100%)
 rename Documentation/{ => security}/credentials.txt (99%)
 rename Documentation/{ => security}/keys-request-key.txt (98%)
 rename Documentation/{ => security}/keys-trusted-encrypted.txt (100%)
 rename Documentation/{ => security}/keys.txt (99%)
 rename Documentation/{ => security}/tomoyo.txt (100%)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
