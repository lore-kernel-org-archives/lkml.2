Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2KTM0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab2KTM0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:26:35 -0500
From: Avi Kivity <avi@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Retire as maintainer
Date: Tue, 20 Nov 2012 14:26:26 +0200
Message-Id: <1353414386-1055-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After six and a half years of writing and maintaining KVM, it is time to
move to new things.  Update my MAINTAINERS entry to reflect that.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 CREDITS     | 5 +++++
 MAINTAINERS | 1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

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
index bb0b27d..6b5b0b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4280,7 +4280,6 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
-M:	Avi Kivity <avi@redhat.com>
 M:	Marcelo Tosatti <mtosatti@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
-- 
1.7.12

