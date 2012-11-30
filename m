Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2K3RA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:00:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2K3RAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:00:25 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 06/32] staging: wlags49_h2: ap_h25: corrects incorrect use of // comments
Date: Fri, 30 Nov 2012 18:58:31 +0200
Message-Id: <1354294737-5735-6-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts C99 // comments to /* */

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h25.c |   68 +++++++++++++++++------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h25.c b/drivers/staging/wlags49_h2/ap_h25.c
index f578800..d3a0faa 100644
--- a/drivers/staging/wlags49_h2/ap_h25.c
+++ b/drivers/staging/wlags49_h2/ap_h25.c
@@ -24,10 +24,10 @@
  */
 
 
-#include "hcfcfg.h"		// to get hcf_16 etc defined as well as
-				// possible settings which inluence mdd.h or dhf.h
-#include "mdd.h"		// to get COMP_ID_STA etc defined
-#include "dhf.h"		// used to be fhfmem.h, to get memblock,plugrecord,
+#include "hcfcfg.h"	/* to get hcf_16 etc defined as well as */
+			/* possible settings which inluence mdd.h or dhf.h */
+#include "mdd.h"	/* to get COMP_ID_STA etc defined */
+#include "dhf.h"	/* used to be fhfmem.h, to get memblock,plugrecord, */
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -3999,56 +3999,56 @@ static const CFG_IDENTITY_STRCT fw_image_infoidentity[] = {
 		sizeof(CFG_IDENTITY_STRCT) / sizeof(hcf_16) - 1,
 		CFG_FW_IDENTITY,
 		COMP_ID_FW_AP,
-		3,							//Variant
-		1,							//Major
-		24							//Minor
+		3,	/* Variant */
+		1,	/* Major */
+		24	/* Minor */
 	},
-	{ 0000, 0000, 0000, 0000, 0000, 0000 }		//endsentinel
+	{ 0000, 0000, 0000, 0000, 0000, 0000 }	/* endsentinel */
 };
 
 static const CFG_PROG_STRCT fw_image_code[] = {
 	{
 		8,
 		CFG_PROG,
-		CFG_PROG_VOLATILE,			// mode
-		0x0148,		// sizeof(fw_image_1_data),
-		0x00000060,					// Target address in NIC Memory
-		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
+		CFG_PROG_VOLATILE,	/* mode */
+		0x0148,			/* sizeof(fw_image_1_data), */
+		0x00000060,		/* Target address in NIC Memory */
+		0x0000,			/* CRC: yes/no	TYPE: primary/station/tertiary */
 		(hcf_8 *)fw_image_1_data
 	},
 	{
 		8,
 		CFG_PROG,
-		CFG_PROG_VOLATILE,			// mode
-		0x2432,		// sizeof(fw_image_2_data),
-		0x00000C16,					// Target address in NIC Memory
-		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
+		CFG_PROG_VOLATILE,	/* mode */
+		0x2432,			/* sizeof(fw_image_2_data), */
+		0x00000C16,		/* Target address in NIC Memory */
+		0x0000,			/* CRC: yes/no	TYPE: primary/station/tertiary */
 		(hcf_8 *)fw_image_2_data
 	},
 	{
 		8,
 		CFG_PROG,
-		CFG_PROG_VOLATILE,			// mode
-		0x194c,		// sizeof(fw_image_3_data),
-		0x001E3048,					// Target address in NIC Memory
-		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
+		CFG_PROG_VOLATILE,	/*  mode */
+		0x194c,			/*  sizeof(fw_image_3_data), */
+		0x001E3048,		/*  Target address in NIC Memory */
+		0x0000,			/*  CRC: yes/no	TYPE: primary/station/tertiary */
 		(hcf_8 *)fw_image_3_data
 	},
 	{
 		8,
 		CFG_PROG,
-		CFG_PROG_VOLATILE,			// mode
-		0xb7e4,		// sizeof(fw_image_4_data),
-		0x001F4000,					// Target address in NIC Memory
-		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
+		CFG_PROG_VOLATILE,	/* mode*/
+		0xb7e4,			/* sizeof(fw_image_4_data),*/
+		0x001F4000,		/* Target address in NIC Memory*/
+		0x0000,			/* CRC: yes/no	TYPE: primary/station/tertiary*/
 		(hcf_8 *)fw_image_4_data
 	},
 	{
 		5,
 		CFG_PROG,
-		CFG_PROG_STOP,				// mode
+		CFG_PROG_STOP,		/* mode*/
 		0000,
-	0x000F2101,					// Start execution address
+		0x000F2101,		/* Start execution address*/
 	},
 	{ 0000, 0000, 0000, 0000, 00000000, 0000, 00000000}
 };
@@ -4059,7 +4059,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_SUPL,
 		COMP_ID_APF,
 		{
-			{ 4, 1, 1 }				//variant, bottom, top
+			{ 4, 1, 1 }	/* variant, bottom, top*/
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4067,8 +4067,8 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_MFI,
 		{
-			{ 7, 3, 3 },				//variant, bottom, top
-			{ 8, 1, 1 }				//variant, bottom, top
+			{ 7, 3, 3 },	/* variant, bottom, top */
+			{ 8, 1, 1 }	/* variant, bottom, top */
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4076,18 +4076,18 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_CFI,
 		{
-			{ 4, 1, 2 }				//variant, bottom, top
+			{ 4, 1, 2 }	/* variant, bottom, top */
 		}
 	},
-	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }			//endsentinel
+	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }	/* endsentinel */
 };
 
 memimage fw_image = {
-	"FUPU7D37dhfwci\001C",			//signature, <format number>, C/Bin type
+	"FUPU7D37dhfwci\001C",			/* signature, <format number>, C/Bin type */
 	(CFG_PROG_STRCT *) fw_image_code,
 	0x000F2101,
-	00000000,					//(dummy) pdaplug
-	00000000,					//(dummy) priplug
+	00000000,				/* (dummy) pdaplug */
+	00000000,				/* (dummy) priplug */
 	(CFG_RANGE20_STRCT *) fw_image_infocompat,
 	(CFG_IDENTITY_STRCT *) fw_image_infoidentity,
 };
-- 
1.7.10.4

