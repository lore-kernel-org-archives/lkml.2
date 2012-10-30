Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab2J3VFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:05:38 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:60012 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934570Ab2J3VEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:04:13 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, linux-pm@vger.kernel.org
Subject: [PATCH 5/6] power: export opp cpufreq functions
Date: Tue, 30 Oct 2012 16:04:15 -0500
Message-Id: <1351631056-25938-6-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-pm@vger.kernel.org

---
 drivers/base/power/opp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index d946864..37dc5f4 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/opp.h>
 #include <linux/of.h>
+#include <linux/module.h>
 
 /*
  * Internal data structure organization with the OPP layer library is as
@@ -643,6 +644,7 @@ int opp_init_cpufreq_table(struct device *dev,
 
 	return 0;
 }
+EXPORT_SYMBOL(opp_init_cpufreq_table);
 
 /**
  * opp_free_cpufreq_table() - free the cpufreq table
@@ -660,6 +662,7 @@ void opp_free_cpufreq_table(struct device *dev,
 	kfree(*table);
 	*table = NULL;
 }
+EXPORT_SYMBOL(opp_free_cpufreq_table);
 #endif		/* CONFIG_CPU_FREQ */
 
 /**
@@ -720,4 +723,5 @@ int of_init_opp_table(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(of_init_opp_table);
 #endif
-- 
1.7.11.7

