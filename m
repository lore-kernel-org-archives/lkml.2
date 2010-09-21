Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0IUNUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:20:23 -0400
Received: from mail-out123.unilogicnetworks.net ([62.133.206.123]:57869 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811Ab0IUNUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:20:21 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 09:20:21 EDT
Subject: [PATCH] Don't show error if Acer WMI is not found
From: "Pascal de Bruijn | Unilogic Networks B.V." 
	<pascal@unilogicnetworks.net>
To: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Organization: Unilogic Networks B.V.
Date: Tue, 21 Sep 2010 14:48:52 +0200
Message-ID: <1285073332.9470.5.camel@carnifex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6e5643d6b1c1e5250d29b8d6d82dae3ec6404055 Mon Sep 17 00:00:00 2001
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
Date: Mon, 30 Aug 2010 09:09:53 +0200
Subject: [PATCH] Don't show error if Acer WMI is not found

---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 2badee2..c8c6537 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1314,7 +1314,7 @@ static int __init acer_wmi_init(void)
 		AMW0_find_mailled();
 
 	if (!interface) {
-		printk(ACER_ERR "No or unsupported WMI interface, unable to "
+		printk(ACER_INFO "No or unsupported WMI interface, unable to "
 				"load\n");
 		return -ENODEV;
 	}
-- 
1.7.0.4



