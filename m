Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1BLTk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:40:59 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1038 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752696Ab1BLTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 10/14] bq27x00: Add MODULE_DEVICE_TABLE
Date: Sat, 12 Feb 2011 20:39:10 +0100
Message-Id: <1297539554-13957-12-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297539554-13957-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

This patch adds MODULE_DEVICE_TABLE for module bq27x00_battery.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/power/bq27x00_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b7a8310..d2e6423 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -672,6 +672,7 @@ static const struct i2c_device_id bq27x00_id[] = {
 	{ "bq27500", BQ27500 },
 	{},
 };
+MODULE_DEVICE_TABLE(i2c, bq27x00_id);
 
 static struct i2c_driver bq27x00_battery_driver = {
 	.driver = {
-- 
1.7.2.3

