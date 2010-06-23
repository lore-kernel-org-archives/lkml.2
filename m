Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0FWDDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:03:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34480 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0FWDDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TntgRZjEqVRYFzlGVoQyX+kr+spey7vcxOvYZrv87oW3i2SOh+MDgKmimJaEhmFm3D
         rzvTLEL/yZA2So5AJmxhBy8mxs6BgbY5H279EHyPpulhZXtfGJaikBWBBhN2sV6rHGg2
         onOAUImJzc+ZLiFE3rDlK6Wja0jbW0b8q4zno=
From: Neal Buckendahl <nealb001@gmail.com>
To: nealb001@gmail.com, davej@redhat.com, trenn@suse.de, prarit@redhat.com,
       venkatesh.pallipadi@intel.com, mathieu.desnoyers@polymtl.ca
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Cpufreq: fix brace coding style issue. This patch fixes up a brace warning found by the checkpatch.pl tool Signed-off-by: Neal Buckendahl <nealb001@tbcnet.com>
Date: Tue, 22 Jun 2010 22:02:44 -0500
Message-Id: <1277262164-6141-1-git-send-email-nealb001@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/cpufreq/cpufreq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 063b218..c622355 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1883,8 +1883,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __refdata cpufreq_cpu_notifier =
-{
+static struct notifier_block __refdata cpufreq_cpu_notifier = {
     .notifier_call = cpufreq_cpu_callback,
 };
 
-- 
1.7.1

