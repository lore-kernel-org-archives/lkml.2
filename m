Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1HaJ0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:26:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1HaJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:26:16 -0400
From: Jiaju Zhang <jjzhang@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiaju Zhang <jjzhang@suse.de>
Subject: [PATCH] Kconfig: Fix help message for DEFAULT_HUNG_TASK_TIMEOUT
Date: Wed, 31 Aug 2011 17:23:46 +0800
Message-Id: <1314782626-19270-1-git-send-email-jjzhang@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing _secs in the help message of config DEFAULT_HUNG_TASK_TIMEOUT.

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
---
 lib/Kconfig.debug |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..f285553 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -248,8 +248,9 @@ config DEFAULT_HUNG_TASK_TIMEOUT
 	  to determine when a task has become non-responsive and should
 	  be considered hung.
 
-	  It can be adjusted at runtime via the kernel.hung_task_timeout
-	  sysctl or by writing a value to /proc/sys/kernel/hung_task_timeout.
+	  It can be adjusted at runtime via the kernel.hung_task_timeout_secs
+	  sysctl or by writing a value to
+	  /proc/sys/kernel/hung_task_timeout_secs.
 
 	  A timeout of 0 disables the check.  The default is two minutes.
 	  Keeping the default should be fine in most cases.
-- 
1.6.0.2

