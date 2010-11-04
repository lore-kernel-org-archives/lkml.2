Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0KDPLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:11:04 -0400
Received: from smtp.nokia.com ([147.243.128.24]:45991 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751775Ab0KDPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:10:59 -0400
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, heikki.krogerus@nokia.com
Subject: [PATCH 1/4] power_supply: isp1704: correct length for storing model
Date: Thu,  4 Nov 2010 16:31:46 +0200
Message-Id: <1288881109-18222-2-git-send-email-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ameya Palande <ameya.palande@nokia.com>

Model should have room to accommodate the trailing null
byte, "isp170[4|7]\0".

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
Acked-by: Heikki Krogerus <heikki.krogerus@nokia.com>
---
 drivers/power/isp1704_charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 7251218..87252e1 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -59,7 +59,7 @@ struct isp1704_charger {
 	struct notifier_block	nb;
 	struct work_struct	work;
 
-	char			model[7];
+	char			model[8];
 	unsigned		present:1;
 };
 
-- 
1.7.1

