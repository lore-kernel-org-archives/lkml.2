Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2HVT14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:27:56 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:47016 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab2HVT1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:27:49 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH RESEND] extcon: fix typos in max77693 driver
Date: Wed, 22 Aug 2012 21:27:41 +0200
Message-Id: <1345663663-4790-2-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
References: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/extcon/extcon-max77693.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
1.7.9.5

