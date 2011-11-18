Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1KRIhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:37:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60625 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KRIg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:36:59 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH] Drivers: hwmon: adm1031: fixed spacing coding style issues
Date: Fri, 18 Nov 2011 01:36:53 -0700
Message-Id: <1321605413-13614-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing coding style issues.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/hwmon/adm1031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 0683e6b..694392b 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -1058,7 +1058,7 @@ static struct adm1031_data *adm1031_update_device(struct device *dev)
 			data->alarm &= 0xc0ff;
 		}
 
-		for (chan=0; chan<(data->chip_type == adm1030 ? 1 : 2); chan++) {
+		for (chan = 0; chan < (data->chip_type == adm1030 ? 1 : 2); chan++) {
 			data->fan_div[chan] =
 			    adm1031_read_value(client, ADM1031_REG_FAN_DIV(chan));
 			data->fan_min[chan] =
-- 
1.7.7.3

