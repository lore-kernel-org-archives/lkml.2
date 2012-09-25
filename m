Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2IYQW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:22:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2IYQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:34 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 19/57] power: remove unused defines.
Date: Tue, 25 Sep 2012 10:12:16 -0600
Message-Id: <1348589574-25655-20-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Cleanup of the ab8500_charger driver.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_charger.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 09edd9c..4155feb 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -112,11 +112,6 @@ enum ab8500_charger_link_status {
 	USB_STAT_CARKIT_1,
 	USB_STAT_CARKIT_2,
 	USB_STAT_ACA_DOCK_CHARGER,
-	USB_STAT_SAMSUNG_USB_PHY_DIS,
-	USB_STAT_SAMSUNG_USB_PHY_ENA,
-	USB_STAT_SAMSUNG_UART_PHY_DIS,
-	USB_STAT_SAMSUNG_UART_PHY_ENA,
-	USB_STAT_MOTOROLA_USB_PHY_ENA,
 };
 
 enum ab8500_usb_state {
-- 
1.7.5.4

