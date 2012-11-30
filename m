Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab2K3Q7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:59:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab2K3Q7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:59:41 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 02/32] staging: wlags49_h2: ap_h25: corrects tabs/spaces syling issues
Date: Fri, 30 Nov 2012 18:58:27 +0200
Message-Id: <1354294737-5735-2-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects tabs and spaces issues as reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h25.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h25.c b/drivers/staging/wlags49_h2/ap_h25.c
index f4491cb..f0fd34f 100644
--- a/drivers/staging/wlags49_h2/ap_h25.c
+++ b/drivers/staging/wlags49_h2/ap_h25.c
@@ -24,10 +24,10 @@
  */
 
 
-#include "hcfcfg.h"				// to get hcf_16 etc defined as well as
-                                // possible settings which inluence mdd.h or dhf.h
-#include "mdd.h"   				//to get COMP_ID_STA etc defined
-#include "dhf.h"   				//used to be "fhfmem.h", to get memblock,plugrecord,
+#include "hcfcfg.h"		// to get hcf_16 etc defined as well as
+				// possible settings which inluence mdd.h or dhf.h
+#include "mdd.h"		// to get COMP_ID_STA etc defined
+#include "dhf.h"		// used to be "fhfmem.h", to get memblock,plugrecord,
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -4048,7 +4048,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		CFG_PROG,
 		CFG_PROG_STOP,				// mode
 		0000,
- 	0x000F2101,					// Start execution address
+	0x000F2101,					// Start execution address
 	},
 	{ 0000, 0000, 0000, 0000, 00000000, 0000, 00000000}
 };
@@ -4059,7 +4059,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_SUPL,
 		COMP_ID_APF,
 		{
-			{ 4, 1, 1 }  				//variant, bottom, top
+			{ 4, 1, 1 }				//variant, bottom, top
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4067,8 +4067,8 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_MFI,
 		{
-			{ 7, 3, 3 }, 				//variant, bottom, top
-			{ 8, 1, 1 }  				//variant, bottom, top
+			{ 7, 3, 3 },				//variant, bottom, top
+			{ 8, 1, 1 }				//variant, bottom, top
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4076,7 +4076,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_CFI,
 		{
-			{ 4, 1, 2 }  				//variant, bottom, top
+			{ 4, 1, 2 }				//variant, bottom, top
 		}
 	},
 	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }			//endsentinel
-- 
1.7.10.4

