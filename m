Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2LMPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:25:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41902 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2LMPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/18] power: ab8500_fg: usleep_range instead of short msleep
Date: Thu, 13 Dec 2012 15:21:28 +0000
Message-Id: <1355412102-14265-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index b1bc893..d974acd 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -956,7 +956,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
 	do {
 		vbat += ab8500_fg_bat_voltage(di);
 		i++;
-		msleep(5);
+		usleep_range(5000, 5001);
 	} while (!ab8500_fg_inst_curr_done(di));
 
 	ab8500_fg_inst_curr_finalize(di, &di->inst_curr);
-- 
1.7.9.5

