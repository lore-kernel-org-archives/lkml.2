Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2BNP1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:27:18 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:51188
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751674Ab2BNP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:27:12 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in kernel-parameters.txt
Date: Wed, 15 Feb 2012 00:26:42 +0900
Message-Id: <1329233202-2576-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "mininum" to "minimum", "conroller" to "controller"
and "explicitely" to "explicitly" in
Documentation/kernel-parameters.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/kernel-parameters.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..cfcc73f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -950,7 +950,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			     controller
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
 			     controllers
-	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
+	i8042.notimeout	[HW] Ignore timeout condition signalled by controller
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
@@ -2434,7 +2434,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			For more information see Documentation/vm/slub.txt.
 
 	slub_min_order=	[MM, SLUB]
-			Determines the mininum page order for slabs. Must be
+			Determines the minimum page order for slabs. Must be
 			lower than slub_max_order.
 			For more information see Documentation/vm/slub.txt.
 
@@ -2600,7 +2600,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	threadirqs	[KNL]
 			Force threading of all interrupt handlers except those
-			marked explicitely IRQF_NO_THREAD.
+			marked explicitly IRQF_NO_THREAD.
 
 	topology=	[S390]
 			Format: {off | on}
-- 
1.7.6.5

