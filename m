Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1BOBjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:39:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36229 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1BOBje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:39:34 -0500
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] usb_storage: realtek_cr patch: fix sparse warning
Date: Tue, 15 Feb 2011 09:38:31 +0800
X-BOX-Message-Id: p1F1dM6a027423
Message-ID: <1297733911-24267-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Fix some sparse warning for realtek_cr patch

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/usb/storage/realtek_cr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index c2bebb3..4f6b25f 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -141,7 +141,7 @@ static int init_realtek_cr(struct us_data *us);
 	.driver_info = (flags)|(USB_US_TYPE_STOR<<24)\
 }
 
-struct usb_device_id realtek_cr_ids[] = {
+static struct usb_device_id realtek_cr_ids[] = {
 #	include "unusual_realtek.h"
 	{ }		/* Terminating entry */
 };
@@ -570,7 +570,7 @@ static void realtek_cr_destructor(void *extra)
 }
 
 #ifdef CONFIG_PM
-void realtek_pm_hook(struct us_data *us, int pm_state)
+static void realtek_pm_hook(struct us_data *us, int pm_state)
 {
 	if (pm_state == US_SUSPEND)
 		(void)config_autodelink_before_power_down(us);
-- 
1.7.4

