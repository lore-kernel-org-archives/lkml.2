Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab2BQIqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:46:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39986 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2BQIqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:46:05 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: lenb@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] drivers/idle/intel_idle.c: Fix confusing code identation
Date: Fri, 17 Feb 2012 06:43:18 -0200
Message-Id: <1329468198-5887-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/idle/intel_idle.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 54ab97b..5e71b98 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -495,8 +495,7 @@ int intel_idle_cpu_init(int cpu)
 		int num_substates;
 
 		if (cstate > max_cstate) {
-			printk(PREFIX "max_cstate %d reached\n",
-			       max_cstate);
+			printk(PREFIX "max_cstate %d reached\n", max_cstate);
 			break;
 		}
 
@@ -512,8 +511,9 @@ int intel_idle_cpu_init(int cpu)
 		dev->states_usage[dev->state_count].driver_data =
 			(void *)get_driver_data(cstate);
 
-			dev->state_count += 1;
-		}
+		dev->state_count += 1;
+	}
+
 	dev->cpu = cpu;
 
 	if (cpuidle_register_device(dev)) {
-- 
1.7.7.6

