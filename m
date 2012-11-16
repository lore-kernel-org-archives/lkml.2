Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2KPQxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:53:18 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47276 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2KPQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:53:17 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 1/3] staging: wlags49_h2: ap_h2: fixes coding style issues
Date: Fri, 16 Nov 2012 18:52:39 +0200
Message-Id: <1353084759-8792-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This corrects several instances of spaces before tabs and incorrect spacing around "*" characters.  It also fixes some 80+ character line length issues, but the majority of such cases have been left as is, as this was probably the author's intention.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h2.c |   56 +++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h2.c b/drivers/staging/wlags49_h2/ap_h2.c
index eb8244c..9bba270 100644
--- a/drivers/staging/wlags49_h2/ap_h2.c
+++ b/drivers/staging/wlags49_h2/ap_h2.c
@@ -25,10 +25,10 @@
  */
 
 
-#include "hcfcfg.h"				/* to get hcf_16 etc defined as well as */
-					/* possible settings which inluence mdd.h or dhf.h */
-#include "mdd.h"   				/* to get COMP_ID_STA etc defined */
-#include "dhf.h"   				/* used to be "fhfmem.h", to get memblock,plugrecord, */
+#include "hcfcfg.h"	/* to get hcf_16 etc defined as well as */
+			/* possible settings which inluence mdd.h or dhf.h */
+#include "mdd.h"	/* to get COMP_ID_STA etc defined */
+#include "dhf.h"	/* used to be "fhfmem.h", to get memblock,plugrecord */
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -3241,9 +3241,9 @@ static const CFG_IDENTITY_STRCT fw_image_infoidentity[] = {
 		sizeof(CFG_IDENTITY_STRCT) / sizeof(hcf_16) - 1,
 		CFG_FW_IDENTITY,
 		COMP_ID_FW_AP,
-		2,							/* Variant /
-		2,							/* Major */
-		36							/* Minor */
+		2,					/* Variant */
+		2,					/* Major */
+		36					/* Minor */
 	},
 	{ 0000, 0000, 0000, 0000, 0000, 0000 }		/* endsentinel */
 };
@@ -3254,43 +3254,43 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		CFG_PROG,
 		CFG_PROG_VOLATILE,			/* mode */
 		0x0146,		/* sizeof(fw_image_1_data), */
-		0x00000060,					/* Target address in NIC Memory */
-		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_1_data
+		0x00000060,	/* Target address in NIC Memory */
+		0x0000,		/* CRC: yes/no	TYPE: primary/station/tertiary */
+		(hcf_8 FAR*) fw_image_1_data
 	},
 	{
 		8,
 		CFG_PROG,
 		CFG_PROG_VOLATILE,			/* mode */
 		0x1918,		/* sizeof(fw_image_2_data), */
-		0x00000C16,					/* Target address in NIC Memory */
-		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_2_data
+		0x00000C16,	/* Target address in NIC Memory */
+		0x0000,		/* CRC: yes/no	TYPE: primary/station/tertiary */
+		(hcf_8 FAR*) fw_image_2_data
 	},
 	{
 		8,
 		CFG_PROG,
 		CFG_PROG_VOLATILE,			/* mode */
 		0x01bc,		/* sizeof(fw_image_3_data), */
-		0x001E252E,					/* Target address in NIC Memory */
-		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_3_data
+		0x001E252E,	/* Target address in NIC Memory */
+		0x0000,		/* CRC: yes/no	TYPE: primary/station/tertiary */
+		(hcf_8 FAR*) fw_image_3_data
 	},
 	{
 		8,
 		CFG_PROG,
 		CFG_PROG_VOLATILE,			/* mode */
 		0xab28,		/* sizeof(fw_image_4_data), */
-		0x001F4000,					/* Target address in NIC Memory */
-		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_4_data
+		0x001F4000,	/* Target address in NIC Memory */
+		0x0000,		/* CRC: yes/no	TYPE: primary/station/tertiary */
+		(hcf_8 FAR*) fw_image_4_data
 	},
 	{
 		5,
 		CFG_PROG,
 		CFG_PROG_STOP,				/* mode*/
 		0000,
-	0x000F1297,					/* Start execution address */
+	0x000F1297,		/* Start execution address */
 	},
 	{ 0000, 0000, 0000, 0000, 00000000, 0000, 00000000}
 };
@@ -3301,7 +3301,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_SUPL,
 		COMP_ID_APF,
 		{
-			{ 2, 2, 4 }  				/* variant, bottom, top */
+			{ 2, 2, 4 }		/* variant, bottom, top */
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -3309,9 +3309,9 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_MFI,
 		{
-			{ 4, 6, 7 }, 				/* variant, bottom, top */
-			{ 5, 6, 7 }, 				/* variant, bottom, top */
-			{ 6, 6, 7 }  				/* variant, bottom, top */
+			{ 4, 6, 7 },		/* variant, bottom, top */
+			{ 5, 6, 7 },		/* variant, bottom, top */
+			{ 6, 6, 7 }		/* variant, bottom, top */
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -3319,14 +3319,16 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_CFI,
 		{
-			{ 2, 1, 2 }  				/* variant, bottom, top */
+			{ 2, 1, 2 }		/* variant, bottom, top */
 		}
 	},
-	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }			/* endsentinel */
+	{ 0000, 0000, 0000, 0000,
+		{ { 0000, 0000, 0000 } }
+	}	/* endsentinel */
 };
 
 memimage fw_image = {
-	"FUPU7D37dhfwci\001C",			/* signature, <format number>, C/Bin type */
+	"FUPU7D37dhfwci\001C",	/* signature, <format number>, C/Bin type */
 	(CFG_PROG_STRCT *) fw_image_code,
 	0x000F1297,
 	00000000,					/* (dummy) pdaplug */
-- 
1.7.10.4

