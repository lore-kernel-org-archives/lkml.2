Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab0KODFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1185 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab0KODFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:40 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/44] drivers/power: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:39 -0800
Message-Id: <2f2ed8aa6745be23063fed55243313839d7ba523.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/power/intel_mid_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 2a10cd3..8397978 100644
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
1.7.3.1.g432b3.dirty

