Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2KTNRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:17:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2KTNQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:16:58 -0500
Message-ID: <50AB82C6.6060901@redhat.com>
Date: Tue, 20 Nov 2012 15:16:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM maintainership update
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

to receive this MAINTAINERS update.  After many years of maintaining KVM,
I am moving on.  It was a real pleasure for me to work with so many talented
and dedicated hackers on this project.

Replacing me will be one of those talented and dedicated hackers, Gleb, who
has authored hundreds of patches in and around KVM.


----------------------------------------------------------------
Avi Kivity (1):
      KVM: Retire as maintainer

Gleb Natapov (1):
      KVM: taking co-maintenance

 CREDITS     | 5 +++++
 MAINTAINERS | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index d8fe12a..2346b09 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1823,6 +1823,11 @@ S: Kattreinstr 38
 S: D-64295
 S: Germany
 
+N: Avi Kivity
+E: avi.kivity@gmail.com
+D: Kernel-based Virtual Machine (KVM)
+S: Ra'annana, Israel
+
 N: Andi Kleen
 E: andi@firstfloor.org
 U: http://www.halobates.de
diff --git a/MAINTAINERS b/MAINTAINERS
index bb0b27d..b273360 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4280,8 +4280,8 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
-M:	Avi Kivity <avi@redhat.com>
 M:	Marcelo Tosatti <mtosatti@redhat.com>
+M:	Gleb Natapov <gleb@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported

-- 
error compiling committee.c: too many arguments to function
