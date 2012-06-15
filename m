Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2FOWUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:20:39 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:24994 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab2FOWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:20:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1339798809!6865335!41
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] staging: comedi: remove unused CONFIG_COMEDI_PCMCIA define
Date: Fri, 15 Jun 2012 15:20:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206151520.22201.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_COMEDI_PCMCIA is not actually a Kconfig option. It is
defined in the comedidev.h header based on another Kconfig
option being enabled.

Just remove it since this define is not used by any of the comedi
drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index e0f3915..c93c87d 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -513,11 +513,5 @@ void comedi_usb_auto_unconfig(struct usb_interface *intf);
 #ifdef CONFIG_COMEDI_PCI_DRIVERS_MODULE
 #define CONFIG_COMEDI_PCI
 #endif
-#ifdef CONFIG_COMEDI_PCMCIA_DRIVERS
-#define CONFIG_COMEDI_PCMCIA
-#endif
-#ifdef CONFIG_COMEDI_PCMCIA_DRIVERS_MODULE
-#define CONFIG_COMEDI_PCMCIA
-#endif
 
 #endif /* _COMEDIDEV_H */
-- 
1.7.7

