Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768771Ab2KOTOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:14:24 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:60634 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768752Ab2KOTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:14:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEALY9pVBbdWOb/2dsb2JhbABEwkGBCIMegT4BEogRvRuMRoYXA5V8hWuKWIJwgVsf
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: add shmall documentation in sysctl/kernel.txt
Date: Thu, 15 Nov 2012 20:14:20 +0100
Message-Id: <1353006860-25704-1-git-send-email-clopez@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing documentation for shmall parameter in sysctl/kernel.txt

Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
---
 Documentation/sysctl/kernel.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 2907ba6..278b1fc 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -542,6 +542,19 @@ are doing anyway :)
 
 ==============================================================
 
+shmall:
+
+This parameter sets the total amount of shared memory pages that
+can be used system wide. Hence, SHMALL should always be at least
+ceil(shmmax/PAGE_SIZE).
+
+If you are not sure what the default PAGE_SIZE is on your Linux
+system, you can run the following command:
+
+# getconf PAGE_SIZE
+
+==============================================================
+
 shmmax:
 
 This value can be used to query and set the run time limit
-- 
1.7.10.4

