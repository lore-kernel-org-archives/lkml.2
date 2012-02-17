Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2BQJJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:09:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55608 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2BQJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:09:47 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: lenb@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH v2] drivers/idle/intel_idle.c: Fix confusing code identation
Date: Fri, 17 Feb 2012 07:06:33 -0200
Message-Id: <1329469593-6164-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a code indentation in the function intel_idle_cpu_init that looks confusing.o

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---

v2 -> Just added a commit message

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

