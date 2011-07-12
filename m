Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1GLGAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:00:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61688 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1GLGAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:00:50 -0400
Subject: [PATCH 1/2] Input: cy8ctmg110_ts - constify i2c_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuli Konttila <samuli.konttila@aavamobile.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 14:00:41 +0800
Message-ID: <1310450441.13592.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/cy8ctmg110_ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index a93c5c2..4481cc5 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -328,7 +328,7 @@ static int __devexit cy8ctmg110_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id cy8ctmg110_idtable[] = {
+static const struct i2c_device_id cy8ctmg110_idtable[] = {
 	{ CY8CTMG110_DRIVER_NAME, 1 },
 	{ }
 };
-- 
1.7.4.1



