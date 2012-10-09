Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2JIHC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:02:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53841 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2JIHC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:02:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: core: Fix typo in comment describing show_bios_limit()
Date: Tue,  9 Oct 2012 12:32:48 +0530
Message-Id: <718816abb84888e786c8bc478104668440b77324.1349766028.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 09 Oct 2012 07:02:50.0897 (UTC) FILETIME=[18B4A810:01CDA5EC]
X-MC-Unique: 112100908025302301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q99731bP003584

show_bios_limit is mistakenly written as show_scaling_driver in a comment
describing purpose of show_bios_limit() routine.

Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fb8a527..021973b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -581,7 +581,7 @@ static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
 }
 
 /**
- * show_scaling_driver - show the current cpufreq HW/BIOS limitation
+ * show_bios_limit - show the current cpufreq HW/BIOS limitation
  */
 static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 {
-- 
1.7.12.rc2.18.g61b472e


