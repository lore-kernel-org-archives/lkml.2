Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab2HWAMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:12:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55856 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab2HWAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:11:56 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-b3-50357546acbc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: pmeerw@pmeerw.net, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, trivial@kernelg.org
Subject: [PATCH 2/4] extcon: fix typos in max77693 driver
Date: Thu, 23 Aug 2012 09:11:47 +0900
Message-id: <1345680707-5906-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jAV33UtMAg5nFFpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK+PKpg72gv88Fc9f32dqYHzM1cXIySEhYCJx73w/C4QtJnHh3nq2
	LkYuDiGBRYwSSx7OY4FwljJJHHzcyQZSxSagJbH/xQ0wW0RATuLJ7T/MIDazQL3E/B3zGEFs
	YQFLiU0LdwLVcHCwCKhK7LpQChLmFXCRWLvnP9QyBYnWZYfYJzByL2BkWMUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kR7L9nUjsYVzZYHGIU4GBU4uHNiDUNEGJNLCuuzD3EKMHBrCTC21UE
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM7L32cYICSQnliSmp2aWpBaBJNl4uCUamCcylQ7j+9f
	vWfHJeGyH0kX/n3m4vvxafVsiw49X8fJW03CBVaKtYXIBD3lslgT9UQr+VZuEm+/S60vP5NK
	4+Rv0/yTdwscPR78POv8+oivbSfyLctKZU0s2OWWqUbbON3r4GStq57y2pWn+XfZmz8Pnjtk
	vip/WFxYt/7a66VaJrU6h3c3iiuxFGckGmoxFxUnAgDdo4eG2wEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 920a609..8bb438b 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -356,7 +356,7 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info,
 		extcon_set_cable_state(info->edev, "MHL", attached);
 		break;
 	default:
-		dev_err(info->dev, "faild to detect %s accessory\n",
+		dev_err(info->dev, "failed to detect %s accessory\n",
 			attached ? "attached" : "detached");
 		dev_err(info->dev, "- adc:0x%x, adclow:0x%x, adc1k:0x%x\n",
 			adc, adclow, adc1k);
@@ -548,7 +548,7 @@ static void max77693_muic_irq_work(struct work_struct *work)
 		curr_adc = info->status[0] & STATUS1_ADC_MASK;
 		curr_adc >>= STATUS1_ADC_SHIFT;
 
-		/* Check accossory state which is either detached or attached */
+		/* Check accessory state which is either detached or attached */
 		if (curr_adc == MAX77693_MUIC_ADC_OPEN)
 			attached = false;
 
@@ -564,7 +564,7 @@ static void max77693_muic_irq_work(struct work_struct *work)
 		curr_chg_type = info->status[1] & STATUS2_CHGTYP_MASK;
 		curr_chg_type >>= STATUS2_CHGTYP_SHIFT;
 
-		/* Check charger accossory state which
+		/* Check charger accessory state which
 		   is either detached or attached */
 		if (curr_chg_type == MAX77693_CHARGER_TYPE_NONE)
 			attached = false;
-- 
1.7.0.4

