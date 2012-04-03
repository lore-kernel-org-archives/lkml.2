Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2DCHdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:33:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27984 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2DCHdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:33:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 10/13] ARM: at91/NAND DT bindings: add comments
Date: Tue,  3 Apr 2012 09:32:54 +0200
Message-Id: <f7a94438cf1e21b2eec044419d9dca214999a9a6.1333437885.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333437885.git.nicolas.ferre@atmel.com>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments to NAND "gpios" property to make it clearer.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 .../devicetree/bindings/mtd/atmel-nand.txt         |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
index 5903ecf..a200695 100644
--- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
@@ -27,13 +27,13 @@ nand0: nand@40000000,0 {
 	reg = <0x40000000 0x10000000
 	       0xffffe800 0x200
 	      >;
-	atmel,nand-addr-offset = <21>;
-	atmel,nand-cmd-offset = <22>;
+	atmel,nand-addr-offset = <21>;	/* ale */
+	atmel,nand-cmd-offset = <22>;	/* cle */
 	nand-on-flash-bbt;
 	nand-ecc-mode = "soft";
-	gpios = <&pioC 13 0
-		 &pioC 14 0
-		 0
+	gpios = <&pioC 13 0	/* rdy */
+		 &pioC 14 0 	/* nce */
+		 0		/* cd */
 		>;
 	partition@0 {
 		...
-- 
1.7.9.4

