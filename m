Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2KTOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34683 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2KTOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:44 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 7/8] staging: wlags49_h2: ap_h2.c: fixes spaces-before-tabs problems
Date: Tue, 20 Nov 2012 16:44:59 +0200
Message-Id: <1353422700-14485-6-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out a few instances of spaces before tabs, as
reported by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h2.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h2.c b/drivers/staging/wlags49_h2/ap_h2.c
index eb8244c..e524153 100644
--- a/drivers/staging/wlags49_h2/ap_h2.c
+++ b/drivers/staging/wlags49_h2/ap_h2.c
@@ -25,10 +25,10 @@
  */
 
 
-#include "hcfcfg.h"				/* to get hcf_16 etc defined as well as */
+#include "hcfcfg.h"			/* to get hcf_16 etc defined as well as */
 					/* possible settings which inluence mdd.h or dhf.h */
-#include "mdd.h"   				/* to get COMP_ID_STA etc defined */
-#include "dhf.h"   				/* used to be "fhfmem.h", to get memblock,plugrecord, */
+#include "mdd.h"			/* to get COMP_ID_STA etc defined */
+#include "dhf.h"			/* used to be "fhfmem.h", to get memblock,plugrecord, */
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -3301,7 +3301,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_SUPL,
 		COMP_ID_APF,
 		{
-			{ 2, 2, 4 }  				/* variant, bottom, top */
+			{ 2, 2, 4 }				/* variant, bottom, top */
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
+			{ 4, 6, 7 },				/* variant, bottom, top */
+			{ 5, 6, 7 },				/* variant, bottom, top */
+			{ 6, 6, 7 }				/* variant, bottom, top */
 		}
 	},
 	{	3 + ((20 * sizeof(CFG_RANGE_SPEC_STRCT)) / sizeof(hcf_16)),
@@ -3319,7 +3319,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 		COMP_ROLE_ACT,
 		COMP_ID_CFI,
 		{
-			{ 2, 1, 2 }  				/* variant, bottom, top */
+			{ 2, 1, 2 }				/* variant, bottom, top */
 		}
 	},
 	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }			/* endsentinel */
-- 
1.7.10.4

