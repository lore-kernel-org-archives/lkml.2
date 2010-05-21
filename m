Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab0EUQwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:09 -0400
Received: from kroah.org ([198.145.64.141]:50320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab0EUQwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/25] serial: bfin_sport_uart: drop redundant cpu depends
Date: Fri, 21 May 2010 09:51:42 -0700
Message-Id: <1274460714-11277-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The BF54xM procs imply the related BF54x define, so no need to check both.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index f41cfce..577d276 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1439,7 +1439,7 @@ config SERIAL_BFIN_SPORT_CONSOLE
 
 config SERIAL_BFIN_SPORT0_UART
 	bool "Enable UART over SPORT0"
-	depends on SERIAL_BFIN_SPORT && !(BF542 || BF542M || BF544 || BF544M)
+	depends on SERIAL_BFIN_SPORT && !(BF542 || BF544)
 	help
 	  Enable UART over SPORT0
 
-- 
1.7.0.3

