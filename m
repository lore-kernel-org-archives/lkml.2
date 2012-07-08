Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2GHAYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:24:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GHAYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:24:49 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH -mm 1/3] notifier error injection: fix copy-and-paste error in Kconfig help
Date: Sun,  8 Jul 2012 09:24:24 +0900
Message-Id: <1341707066-10742-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc-pseries-reconfig-notifier-error-injection-module.patch
in -mm tree has a copy-and-paste error in Kconfig help.

The module name should be pSeries-reconfig-notifier-error-inject.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8f8e226..1b77bc7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1179,7 +1179,7 @@ config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
 	  notified, write the error code to "actions/<notifier event>/error".
 
 	  To compile this code as a module, choose M here: the module will
-	  be called memory-notifier-error-inject.
+	  be called pSeries-reconfig-notifier-error-inject.
 
 	  If unsure, say N.
 
-- 
1.7.10.4

