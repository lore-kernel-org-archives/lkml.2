Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2LSQpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:45:19 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45319 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab2LSQpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:45:06 -0500
From: Alexander Kartashov <alekskartashov@parallels.com>
To: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <gorcunov@openvz.org>, <xemul@parallels.com>,
        Alexander Kartashov <alekskartashov@parallels.com>
Subject: [PATCH 2/3] kcmp: Drop x86 dependancy
Date: Wed, 19 Dec 2012 20:44:29 +0400
Message-ID: <1355935470-21001-3-git-send-email-alekskartashov@parallels.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355935470-21001-1-git-send-email-alekskartashov@parallels.com>
References: <20689.54803.684081.31731@pilspetsen.it.uu.se>
 <1355935470-21001-1-git-send-email-alekskartashov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
---
 kernel/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 86e3285..9f7a139 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
-- 
1.7.9.5

