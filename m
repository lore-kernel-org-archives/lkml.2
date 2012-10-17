Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2JQFVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:21:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38256 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JQFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:21:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: Improve debug prints
Date: Wed, 17 Oct 2012 10:50:23 +0530
Message-Id: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 17 Oct 2012 05:21:26.0860 (UTC) FILETIME=[41A448C0:01CDAC27]
X-MC-Unique: 112101706212801801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9H5Lb6B002063

With debug options on, it is difficult to locate cpufreq core's debug prints.
Fix this by prefixing debug prints with:

"cpufreq: "

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c             | 2 ++
 drivers/cpufreq/cpufreq_performance.c | 2 ++
 drivers/cpufreq/cpufreq_powersave.c   | 2 ++
 drivers/cpufreq/cpufreq_userspace.c   | 2 ++
 drivers/cpufreq/freq_table.c          | 2 ++
 5 files changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index db6e337..bcbc99d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) "cpufreq: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index f13a8a9..67e3232 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) "cpufreq: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 4c2eb51..eb974b6 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) "cpufreq: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index bedac1a..6d7ccdb 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) "cpufreq: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/smp.h>
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 90431cb..246949c 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "cpufreq: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-- 
1.7.12.rc2.18.g61b472e


