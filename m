Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab1CXUTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab1CXUTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EHg942ljbPj0zZIQ6ohbGyacaKfVZOVIAUycaPWKLV52zi8J80kck9aMAtyxzxVkWc
         pg7G8i9I7w4zxo2XiRVd9FivByGOBY4O8kg++yF8QRGGULrHmCkgPmytnF6oQqyEz7VY
         7EK2sdkdATcpcZX/gdRfUDvp2UiYdpV5J4F1Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 09/21]drivers:power:intel_mid_battery.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:28 -0700
Message-Id: <1300997920-31573-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

