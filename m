Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839Ab1IOUP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:15:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:9031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934680Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="51959236"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/27] Initconst section fixes for hwmon
Date: Thu, 15 Sep 2011 13:09:39 -0700
Message-Id: <1316117394-21666-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/w83627ehf.c |   16 ++++++++--------
 drivers/hwmon/w83627hf.c  |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index f2b377c..85827a3 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2309,14 +2309,14 @@ static struct platform_driver w83627ehf_driver = {
 static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 				 struct w83627ehf_sio_data *sio_data)
 {
-	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
-	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
-	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
-	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
-	static const char __initdata sio_name_W83667HG[] = "W83667HG";
-	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
-	static const char __initdata sio_name_NCT6775[] = "NCT6775F";
-	static const char __initdata sio_name_NCT6776[] = "NCT6776F";
+	static const char __initconst sio_name_W83627EHF[] = "W83627EHF";
+	static const char __initconst sio_name_W83627EHG[] = "W83627EHG";
+	static const char __initconst sio_name_W83627DHG[] = "W83627DHG";
+	static const char __initconst sio_name_W83627DHG_P[] = "W83627DHG-P";
+	static const char __initconst sio_name_W83667HG[] = "W83667HG";
+	static const char __initconst sio_name_W83667HG_B[] = "W83667HG-B";
+	static const char __initconst sio_name_NCT6775[] = "NCT6775F";
+	static const char __initconst sio_name_NCT6776[] = "NCT6776F";
 
 	u16 val;
 	const char *sio_name;
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index bde50e3..d152014 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -1129,7 +1129,7 @@ static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 	int err = -ENODEV;
 	u16 val;
 
-	static const __initdata char *names[] = {
+	static __initconst char *const names[] = {
 		"W83627HF",
 		"W83627THF",
 		"W83697HF",
-- 
1.7.4.4

