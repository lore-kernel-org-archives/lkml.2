Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1KVMKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:10:36 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45429 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1KVMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:10:35 -0500
Message-ID: <1321963833.18752.3.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] serial: Kconfig: drop unknown symbol 'ARCH_IMX'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 13:10:33 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c8fdbc9bd ("[ARM] Remove arch-imx from build system") dropped
ARCH_IMX. So this last reference to ARCH_IMX has been an
(inconsequential) nop since v2.6.31. And because ARCH_MXC practically
implies ARM we can also drop the reference to the latter symbol.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 5f479da..edbc9b7 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -808,7 +808,7 @@ config BFIN_UART3_CTSRTS
 
 config SERIAL_IMX
 	bool "IMX serial port support"
-	depends on ARM && (ARCH_IMX || ARCH_MXC)
+	depends on ARCH_MXC
 	select SERIAL_CORE
 	select RATIONAL
 	help
-- 
1.7.7.3



