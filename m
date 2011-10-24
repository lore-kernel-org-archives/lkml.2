Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1JXOJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:09:52 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58792 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1JXOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:09:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH V3 (bugfix to fold)] ARM: at91: usb_a9g20.dts: fix memory location
Date: Mon, 24 Oct 2011 16:09:36 +0200
Message-Id: <1319465376-8613-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <d139db89b4e9830e813abf1329ce1ac499653f2c.1319464310.git.nicolas.ferre@atmel.com>
References: <d139db89b4e9830e813abf1329ce1ac499653f2c.1319464310.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/usb_a9g20.dts |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/usb_a9g20.dts b/arch/arm/boot/dts/usb_a9g20.dts
index a060f6c..d66e2c0 100644
--- a/arch/arm/boot/dts/usb_a9g20.dts
+++ b/arch/arm/boot/dts/usb_a9g20.dts
@@ -16,7 +16,7 @@
 		bootargs = "mem=64M console=ttyS0,115200 mtdparts=atmel_nand:128k(at91bootstrap),256k(barebox)ro,128k(bareboxenv),128k(bareboxenv2),4M(kernel),120M(rootfs),-(data) root=/dev/mtdblock5 rw rootfstype=ubifs";
 	};
 
-	memory@70000000 {
+	memory@20000000 {
 		reg = <0x20000000 0x4000000>;
 	};
 
-- 
1.7.5.4

