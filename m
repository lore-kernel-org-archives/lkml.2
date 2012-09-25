Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2IYQN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab2IYQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:20 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 09/57] power: ab8500_fg: usleep_range instead of short msleep
Date: Tue, 25 Sep 2012 10:12:06 -0600
Message-Id: <1348589574-25655-10-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Jonas ABERG <jonas.aberg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 1e02b00..0db17c7 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -957,7 +957,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
 	do {
 		vbat += ab8500_fg_bat_voltage(di);
 		i++;
-		msleep(5);
+		usleep_range(5000, 5001);
 	} while (!ab8500_fg_inst_curr_done(di));
 
 	ab8500_fg_inst_curr_finalize(di, &di->inst_curr);
-- 
1.7.5.4

