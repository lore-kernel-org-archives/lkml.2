Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0INEYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1981 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0INEYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH next 03/16] arch/microblaze: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:49 -0700
Message-Id: <8ed12f6c1a30747223f4c684ae31ce5c8846dd13.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/microblaze/kernel/heartbeat.c |   10 +++++-----
 arch/microblaze/kernel/timer.c     |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
index 5227517..f8bc2d7 100644
--- a/arch/microblaze/kernel/heartbeat.c
+++ b/arch/microblaze/kernel/heartbeat.c
@@ -47,11 +47,11 @@ void setup_heartbeat(void)
 	struct device_node *gpio = NULL;
 	int *prop;
 	int j;
-	char *gpio_list[] = {
-				"xlnx,xps-gpio-1.00.a",
-				"xlnx,opb-gpio-1.00.a",
-				NULL
-			};
+	const char * const gpio_list[] = {
+		"xlnx,xps-gpio-1.00.a",
+		"xlnx,opb-gpio-1.00.a",
+		NULL
+	};
 
 	for (j = 0; gpio_list[j] != NULL; j++) {
 		gpio = of_find_compatible_node(NULL, NULL, gpio_list[j]);
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index ec7df67..da9d1e5 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -258,12 +258,12 @@ void __init time_init(void)
 				0
 			};
 #endif
-	char *timer_list[] = {
-				"xlnx,xps-timer-1.00.a",
-				"xlnx,opb-timer-1.00.b",
-				"xlnx,opb-timer-1.00.a",
-				NULL
-			};
+	const char * const timer_list[] = {
+		"xlnx,xps-timer-1.00.a",
+		"xlnx,opb-timer-1.00.b",
+		"xlnx,opb-timer-1.00.a",
+		NULL
+	};
 
 	for (i = 0; timer_list[i] != NULL; i++) {
 		timer = of_find_compatible_node(NULL, NULL, timer_list[i]);
-- 
1.7.3.rc1

