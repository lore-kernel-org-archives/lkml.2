Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0FXNwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:52:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0FXNwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vhUZAzW3OLvtxxX6ok7gdz8lhy94T8j4oUaWEuGlAPCcCUwwtELllbe0txcQsqF95W
         RnEaXB28rShwET1UxqpQQFuQKvjK/a8QaEJIHQAGDvw5Kpmj1YZJutW4Zn3nVM7v8StO
         k3GI2zEcfI7evmKwaCII7oX8RH6UevqYnPlZ0=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] tps65023: Allow registering similar TPS65021
Date: Thu, 24 Jun 2010 15:49:49 +0200
Message-Id: <1277387389-5103-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65021 is an older model and is slightly weaker (can supply less current),
otherwise is the same.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index f50afc9..cd6d4fc 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -585,6 +585,8 @@ static const struct tps_info tps65023_regs[] = {
 static const struct i2c_device_id tps_65023_id[] = {
 	{.name = "tps65023",
 	.driver_data = (unsigned long) tps65023_regs,},
+	{.name = "tps65021",
+	.driver_data = (unsigned long) tps65023_regs,},
 	{ },
 };
 
-- 
1.7.1

