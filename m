Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab1KJDhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:37:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951Ab1KJDhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:37:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:47 2011
Message-Id: <20111109213147.137916759@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vincent Palatin <vpalatin@chromium.org>
Subject: [050/264] usb-storage: fix realtek cr configuration
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Palatin <vpalatin@chromium.org>

commit 839f245f8f1e7d7efd7ba12a7d735f13e8293a2b upstream.

A typo in the configuration variable name prevents from activating the
USB autosuspend on the device.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -42,7 +42,7 @@ config USB_STORAGE_REALTEK
 
 config REALTEK_AUTOPM
 	bool "Realtek Card Reader autosuspend support"
-	depends on USB_STORAGE_REALTEK && CONFIG_PM_RUNTIME
+	depends on USB_STORAGE_REALTEK && PM_RUNTIME
 	default y
 
 config USB_STORAGE_DATAFAB


