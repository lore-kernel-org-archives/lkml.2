Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2BYDiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:38:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2BYDh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:37:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.223.167 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330141073.10677.1.camel@phoenix>
Subject: [PATCH 2/2] mfd: include linux/mfd/pcf50633/mbc.h in pcf50633-irq.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Harald Welte <laforge@openmoko.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Sat, 25 Feb 2012 11:37:53 +0800
In-Reply-To: <1330141014.10677.0.camel@phoenix>
References: <1330141014.10677.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/mfd/pcf50633/mbc.h instead of duplicating the same defines.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-irq.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/pcf50633-irq.c b/drivers/mfd/pcf50633-irq.c
index 048a3b9..498286c 100644
--- a/drivers/mfd/pcf50633-irq.c
+++ b/drivers/mfd/pcf50633-irq.c
@@ -19,12 +19,7 @@
 #include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
-
-/* Two MBCS registers used during cold start */
-#define PCF50633_REG_MBCS1		0x4b
-#define PCF50633_REG_MBCS2		0x4c
-#define PCF50633_MBCS1_USBPRES 		0x01
-#define PCF50633_MBCS1_ADAPTPRES	0x01
+#include <linux/mfd/pcf50633/mbc.h>
 
 int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
 			void (*handler) (int, void *), void *data)
-- 
1.7.5.4



