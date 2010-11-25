Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0KYDCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 22:02:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48048 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0KYDCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 22:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=QFCRkytqvyDBK5liP6SFUS18PBh7CT6PPYoEKIPrTB/06005743S8gT1RBeV82Luo0
         9nEMGzWhPWjrDZ/+pndN8i9aFHHHt9vi3kYfNsnXnUNU4wI7aT4P8ssg/uy2ND7O8j2t
         pu0lwR+fLKSw53bNWPx3Vos9mrkfBpE1+hLFY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH] init: Kconfig: fix typo
Date: Thu, 25 Nov 2010 04:02:10 +0100
Message-Id: <1290654130-26114-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.2.316.g4da1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/feautre/feature/

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c972899..dd43d8e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -620,7 +620,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	help
 	  Memory Resource Controller Swap Extension comes with its price in
 	  a bigger memory consumption. General purpose distribution kernels
-	  which want to enable the feautre but keep it disabled by default
+	  which want to enable the feature but keep it disabled by default
 	  and let the user enable it by swapaccount boot command line
 	  parameter should have this option unselected.
 	  For those who want to have the feature enabled by default should
-- 
1.7.3.2.316.g4da1c

