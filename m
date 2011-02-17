Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1BQC7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46541 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1BQC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rCIp5SHI4FmX12Eco9PhOXtwT6X+KjA7inPqAy1yNDuBAJZ9JU5lGRUwRKdxxsSsGW
         2Mdt+1uZkwOZCr7hL39PvD7kNZ4ALY3ng4IEBA0N4hB3JOG6JDXGaJAY8rMGT3gf1rWk
         uF3CDJYbgParU06GaVqSj5OcevWrG/vUCV7S4=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 04/10] Staging: tidspbridge: fixed indent coding style issue
Date: Thu, 17 Feb 2011 03:58:48 +0100
Message-Id: <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index eef149b..51cae1a 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -567,21 +567,21 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 	}
 	if (!status) {
-/*PM_IVA2GRPSEL_PER = 0xC0;*/
+		/*PM_IVA2GRPSEL_PER = 0xC0;*/
 		temp = readl(resources->dw_per_pm_base + 0xA8);
 		temp = (temp & 0xFFFFFF30) | 0xC0;
 		writel(temp, resources->dw_per_pm_base + 0xA8);
 
-/*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
+		/*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
 		temp = readl(resources->dw_per_pm_base + 0xA4);
 		temp = (temp & 0xFFFFFF3F);
 		writel(temp, resources->dw_per_pm_base + 0xA4);
-/*CM_SLEEPDEP_PER |= 0x04; */
+		/*CM_SLEEPDEP_PER |= 0x04; */
 		temp = readl(resources->dw_per_base + 0x44);
 		temp = (temp & 0xFFFFFFFB) | 0x04;
 		writel(temp, resources->dw_per_base + 0x44);
 
-/*CM_CLKSTCTRL_IVA2 = 0x00000003 -To Allow automatic transitions */
+		/*CM_CLKSTCTRL_IVA2 = 0x00000003 -To Allow automatic transitions */
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_ENABLE_AUTO,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 
-- 
1.7.1

