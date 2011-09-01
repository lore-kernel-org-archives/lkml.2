Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab1IAVFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:05:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:05:39 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        edwin_rong <edwin_rong@realsil.com.cn>,
        wwang <wei_wang@realsil.com.cn>, Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] usb-storage: fix realtek cr configuration
Date: Thu,  1 Sep 2011 14:05:15 -0700
Message-Id: <1314911115-32619-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A typo in the configuration variable name prevents from activating the
USB autosuspend on the device.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/usb/storage/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index bedc4b9..fe2d803 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -42,7 +42,7 @@ config USB_STORAGE_REALTEK
 
 config REALTEK_AUTOPM
 	bool "Realtek Card Reader autosuspend support"
-	depends on USB_STORAGE_REALTEK && CONFIG_PM_RUNTIME
+	depends on USB_STORAGE_REALTEK && PM_RUNTIME
 	default y
 
 config USB_STORAGE_DATAFAB
-- 
1.7.3.1

