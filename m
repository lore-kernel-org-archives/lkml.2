Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab1CXT1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984Ab1CXT1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oaP7tSQ3o+eZU7mieI44Q4eGpuB9UdpAbzkxNBDhfNGMATB4f/eK1b7l6ipUO15Ofp
         as11yPIG31rgh33/uHpbi1Dj0oXT10bPVF8kaRmwcvms0tkSqlJOTxR7qONE5/LZJBLj
         0USajeJDRs3as5ECSWvY/Jweyy5rtWxvEPRQI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 09/21]drivers:power:intel_mid_battery.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:47 -0700
Message-Id: <1300994819-30930-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/power/intel_mid_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index bce3a01..cffcb7c 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -522,7 +522,7 @@ static int pmic_battery_set_charger(struct pmic_power_module_info *pbi,
 	if (retval) {
 		dev_warn(pbi->dev, "%s(): ipc pmic read failed\n",
 								__func__);
-		return retval;;
+		return retval;
 	}
 
 	return 0;
-- 
1.7.4.1

