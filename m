Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383Ab0EURDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:03:36 -0400
Received: from kroah.org ([198.145.64.141]:50317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934096Ab0EUQwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/25] serial: bfin_sport_uart: drop the experimental markings
Date: Fri, 21 May 2010 09:51:41 -0700
Message-Id: <1274460714-11277-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Should be stable now ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 6325830..f41cfce 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1423,8 +1423,8 @@ config SERIAL_SC26XX_CONSOLE
 	  Support for Console on SC2681/SC2692 serial ports.
 
 config SERIAL_BFIN_SPORT
-	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
-	depends on BLACKFIN && EXPERIMENTAL
+	tristate "Blackfin SPORT emulate UART"
+	depends on BLACKFIN
 	select SERIAL_CORE
 	help
 	  Enable SPORT emulate UART on Blackfin series.
-- 
1.7.0.3

