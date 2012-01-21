Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2AUKK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab2AUKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:10:20 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH 1/3] xgifb: checkpatch cleanup, braces
Date: Sat, 21 Jan 2012 02:10:10 -0800
Message-Id: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up XGI_main_26.c and removed some unneeded braces to keep with code
conventions.

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2502c49..dd97b73 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2033,13 +2033,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		xgifb_info->hasVB = HASVB_NONE;
 	} else if (xgifb_info->chip == XG21) {
 		CR38 = xgifb_reg_get(XGICR, 0x38);
-		if ((CR38&0xE0) == 0xC0) {
+		if ((CR38&0xE0) == 0xC0)
 			xgifb_info->display2 = XGIFB_DISP_LCD;
-		} else if ((CR38&0xE0) == 0x60) {
+		else if ((CR38&0xE0) == 0x60)
 			xgifb_info->hasVB = HASVB_CHRONTEL;
-		} else {
+		else
 			xgifb_info->hasVB = HASVB_NONE;
-		}
 	} else {
 		XGIfb_get_VB_type(xgifb_info);
 	}
@@ -2147,9 +2146,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 					if (tmp & 0x20) {
 						tmp = xgifb_reg_get(
 							XGIPART1, 0x13);
-						if (tmp & 0x04) {
-							/* XGI_Pr.XGI_UseLCDA = 1; */
-						}
 					}
 				}
 			}
-- 
1.7.5.4

