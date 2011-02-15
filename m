Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1BOJD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:03:57 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54717 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1BOJDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:03:54 -0500
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] usb_storage: realtek_cr patch: add const modifier
Date: Tue, 15 Feb 2011 17:02:47 +0800
X-BOX-Message-Id: p1F93g9t026467
Message-ID: <1297760567-4053-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Add const modifier before global variable realtek_cr_ids.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/usb/storage/realtek_cr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 4f6b25f..d509a4a 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -141,7 +141,7 @@ static int init_realtek_cr(struct us_data *us);
 	.driver_info = (flags)|(USB_US_TYPE_STOR<<24)\
 }
 
-static struct usb_device_id realtek_cr_ids[] = {
+static const struct usb_device_id realtek_cr_ids[] = {
 #	include "unusual_realtek.h"
 	{ }		/* Terminating entry */
 };
-- 
1.7.4

