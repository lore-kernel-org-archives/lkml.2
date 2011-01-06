Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1AFWXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:50 -0500
Received: from kroah.org ([198.145.64.141]:55653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1AFWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/36] serial: ifx6x60: The IFX requires SPI
Date: Thu,  6 Jan 2011 14:23:03 -0800
Message-Id: <1294352605-31906-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Correct the KConfig as noted by Greg.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 388e371..9f6daae 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1644,7 +1644,7 @@ config SERIAL_ALTERA_UART_CONSOLE
 
 config SERIAL_IFX6X60
         tristate "SPI protocol driver for Infineon 6x60 modem (EXPERIMENTAL)"
-	depends on GPIOLIB && EXPERIMENTAL
+	depends on GPIOLIB && SPI && EXPERIMENTAL
 	help
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
-- 
1.7.3.2

