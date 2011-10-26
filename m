Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1JZCaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 22:30:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37091 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1JZCaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 22:30:16 -0400
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Gardner <gardner.ben@gmail.com>
Subject: [PATCH] rtc-isl1208: Add support for the ISL1218
Date: Tue, 25 Oct 2011 21:30:06 -0500
Message-Id: <1319596206-23266-1-git-send-email-gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISL1218 chip is identical to the ISL1208, except that it has 6
additional user-storage registers. This patch does not enable access 
to those additional registers, but only adds the chip name to the list.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
---
 drivers/rtc/rtc-isl1208.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index da8beb8..ea10736 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -697,6 +697,7 @@ isl1208_remove(struct i2c_client *client)
 
 static const struct i2c_device_id isl1208_id[] = {
 	{ "isl1208", 0 },
+	{ "isl1218", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, isl1208_id);
-- 
1.7.7

