Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2FSXUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:20:48 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:28936 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2FSXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1340148028!7218327!9
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] staging: comedi: Kconfig: menuconfig options should be bool
Date: Tue, 19 Jun 2012 16:20:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191620.28387.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menuconfig options to enable the various comedi driver types
should be bool not tristate. They don't directly affect the
building of the kernel, they just allow other options to be
selected.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 03ee2d0..974c668 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -33,7 +33,7 @@ config COMEDI_DEFAULT_BUF_MAXSIZE_KB
 	  channels running at 100 kHz has 2-4 seconds of buffer.
 
 menuconfig COMEDI_MISC_DRIVERS
-	tristate "Comedi misc drivers"
+	bool "Comedi misc drivers"
 	---help---
 	  Enable comedi misc drivers to be built
 
@@ -100,7 +100,7 @@ config COMEDI_SKEL
 endif # COMEDI_MISC_DRIVERS
 
 menuconfig COMEDI_ISA_DRIVERS
-	tristate "Comedi ISA and PC/104 drivers"
+	bool "Comedi ISA and PC/104 drivers"
 	depends on ISA
 	---help---
 	  Enable comedi ISA and PC/104 drivers to be built
@@ -540,7 +540,7 @@ config COMEDI_POC
 endif # COMEDI_ISA_DRIVERS
 
 menuconfig COMEDI_PCI_DRIVERS
-	tristate "Comedi PCI drivers"
+	bool "Comedi PCI drivers"
 	depends on PCI
 	---help---
 	  Enable comedi PCI drivers to be built
@@ -1095,7 +1095,7 @@ config COMEDI_SSV_DNP
 endif # COMEDI_PCI_DRIVERS
 
 menuconfig COMEDI_PCMCIA_DRIVERS
-	tristate "Comedi PCMCIA drivers"
+	bool "Comedi PCMCIA drivers"
 	depends on PCMCIA
 	---help---
 	  Enable comedi PCMCIA and PCCARD drivers to be built
@@ -1178,7 +1178,7 @@ config COMEDI_QUATECH_DAQP_CS
 endif # COMEDI_PCMCIA_DRIVERS
 
 menuconfig COMEDI_USB_DRIVERS
-	tristate "Comedi USB drivers"
+	bool "Comedi USB drivers"
 	depends on USB
 	---help---
 	  Enable comedi USB drivers to be built
-- 
1.7.11

