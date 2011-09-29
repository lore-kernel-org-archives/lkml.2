Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1I2I4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:56:02 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:46661 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1I2I4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:56:00 -0400
Subject: [PATCH] [TRIVIAL] btmrvl_sdio: fix typo 'btmrvl_sdio_sd6888'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 10:55:47 +0200
Message-ID: <1317286547.30144.1.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be 'btmrvl_sdio_sd8688', of course.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This one was even compile tested!

 drivers/bluetooth/btmrvl_sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 7f521d4..c827d73 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -81,7 +81,7 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_8787 = {
 	.io_port_2 = 0x7a,
 };
 
-static const struct btmrvl_sdio_device btmrvl_sdio_sd6888 = {
+static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
 	.helper		= "sd8688_helper.bin",
 	.firmware	= "sd8688.bin",
 	.reg		= &btmrvl_reg_8688,
@@ -98,7 +98,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8787 = {
 static const struct sdio_device_id btmrvl_sdio_ids[] = {
 	/* Marvell SD8688 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x9105),
-			.driver_data = (unsigned long) &btmrvl_sdio_sd6888 },
+			.driver_data = (unsigned long) &btmrvl_sdio_sd8688 },
 	/* Marvell SD8787 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x911A),
 			.driver_data = (unsigned long) &btmrvl_sdio_sd8787 },
-- 
1.7.4.4



