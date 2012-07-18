Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2GRAIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:08:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2GRAIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:08:45 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        linux-pm@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] cpufreq: Fix typo in cpufreq driver
Date: Wed, 18 Jul 2012 09:09:27 +0900
Message-Id: <1342570167-13076-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.2.249.g31c7954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in cpufreq driver.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/cpufreq/s3c2416-cpufreq.c | 4 ++--
 drivers/cpufreq/speedstep-ich.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 50d2f15..bcc053b 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -153,7 +153,7 @@ static int s3c2416_cpufreq_enter_dvs(struct s3c2416_data *s3c_freq, int idx)
 	if (s3c_freq->vddarm) {
 		dvfs = &s3c2416_dvfs_table[idx];
 
-		pr_debug("cpufreq: setting regultor to %d-%d\n",
+		pr_debug("cpufreq: setting regulator to %d-%d\n",
 			 dvfs->vddarm_min, dvfs->vddarm_max);
 		ret = regulator_set_voltage(s3c_freq->vddarm,
 					    dvfs->vddarm_min,
@@ -186,7 +186,7 @@ static int s3c2416_cpufreq_leave_dvs(struct s3c2416_data *s3c_freq, int idx)
 	if (s3c_freq->vddarm) {
 		dvfs = &s3c2416_dvfs_table[idx];
 
-		pr_debug("cpufreq: setting regultor to %d-%d\n",
+		pr_debug("cpufreq: setting regulator to %d-%d\n",
 			 dvfs->vddarm_min, dvfs->vddarm_max);
 		ret = regulator_set_voltage(s3c_freq->vddarm,
 					    dvfs->vddarm_min,
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 7432b3a..e29b59a 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -203,7 +203,7 @@ static unsigned int speedstep_detect_chipset(void)
 	if (speedstep_chipset_dev) {
 		/* speedstep.c causes lockups on Dell Inspirons 8000 and
 		 * 8100 which use a pretty old revision of the 82815
-		 * host brige. Abort on these systems.
+		 * host bridge. Abort on these systems.
 		 */
 		static struct pci_dev *hostbridge;
 
-- 
1.7.11.2.249.g31c7954

