Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1KRITx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:19:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48232 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KRITw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:19:52 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 34/34] Drivers: hwmon: adm1031: fixed a coding style issue
Date: Fri, 18 Nov 2011 01:19:45 -0700
Message-Id: <1321604385-13240-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/hwmon/adm1031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 6e80cf0..0bd2ae7 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -230,7 +230,7 @@ static const auto_chan_table_t auto_channel_select_table_adm1030 = {
  */
 static int
 get_fan_auto_nearest(struct adm1031_data *data,
-		     int chan, u8 val, u8 reg, u8 * new_reg)
+		     int chan, u8 val, u8 reg, u8 *new_reg)
 {
 	int i;
 	int first_match = -1, exact_match = -1;
-- 
1.7.7.3

