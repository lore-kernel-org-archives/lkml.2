Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2EMQHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:07:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2EMQHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:48 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/7] usb: remove unneeded default value
Date: Sun, 13 May 2012 18:07:08 +0200
Message-Id: <1336925230-2853-6-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no default value is specified, then 'n' is used so the default value
used here is not needed. Furthermore, we should never change default
values depending on EXPERT mode. EXPERT mode should only make options
visible, not change them.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/usb/core/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 18d02e3..04aec50 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -125,7 +125,6 @@ config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
 	depends on USB_OTG || EXPERT
 	default y if USB_OTG
-	default n if EXPERT
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
-- 
1.7.10.2

