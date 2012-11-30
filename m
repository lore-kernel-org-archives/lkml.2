Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab2K3RCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:02:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55829 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031155Ab2K3RCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:02:05 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 16/32] staging: wlags49_h2: sta_h2: fixes spaces-before-tabs problems
Date: Fri, 30 Nov 2012 18:58:41 +0200
Message-Id: <1354294737-5735-16-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit various cases where there were spaces before tabs, as
reported by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/sta_h2.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
index 00dffe2..6fc61ba 100644
--- a/drivers/staging/wlags49_h2/sta_h2.c
+++ b/drivers/staging/wlags49_h2/sta_h2.c
@@ -25,10 +25,10 @@
  */
 
 
-#include "hcfcfg.h"				// to get hcf_16 etc defined as well as
-                                // possible settings which influence mdd.h or dhf.h
-#include "mdd.h"   				//to get COMP_ID_STA etc defined
-#include "dhf.h"   				//used to be "fhfmem.h", to get memblock,plugrecord,
+#include "hcfcfg.h"	// to get hcf_16 etc defined as well as
+			// possible settings which influence mdd.h or dhf.h
+#include "mdd.h"	// to get COMP_ID_STA etc defined
+#include "dhf.h"	// used to be "fhfmem.h", to get memblock,plugrecord,
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -4433,7 +4433,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		CFG_PROG,
 		CFG_PROG_STOP,				// mode
 		0000,
- 	0x000F368E,					// Start execution address
+	0x000F368E,		// Start execution address
 	},
 	{ 0000, 0000, 0000, 0000, 00000000, 0000, 00000000}
 };
@@ -4444,7 +4444,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_SUPL,
 		COMP_ID_STA,
 		{
-			{ 2, 2, 5 }  				//variant, bottom, top
+			{ 2, 2, 5 }				//variant, bottom, top
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4452,9 +4452,9 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_MFI,
 		{
-			{ 4, 6, 7 }, 				//variant, bottom, top
-			{ 5, 6, 7 }, 				//variant, bottom, top
-			{ 6, 6, 7 }  				//variant, bottom, top
+			{ 4, 6, 7 },				//variant, bottom, top
+			{ 5, 6, 7 },				//variant, bottom, top
+			{ 6, 6, 7 }				//variant, bottom, top
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -4462,7 +4462,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_CFI,
 		{
-			{ 2, 1, 2 }  				//variant, bottom, top
+			{ 2, 1, 2 }				//variant, bottom, top
 		}
 	},
 	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }	//endsentinel
-- 
1.7.10.4

