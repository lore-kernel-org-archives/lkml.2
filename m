Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2FSXU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:20:27 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:10881 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2FSXUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1340148021!6371493!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] staging: comedi: remove unused CONFIG_COMEDI_PCMCIA define
Date: Tue, 19 Jun 2012 16:20:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191620.17495.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_COMEDI_PCMCIA is not actually a Kconfig option. It is
defined in the comedidev.h header based on another Kconfig
option being enbled.

Just remove it since the define is not used by any of the comedi
drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h | 6 ------
 1 file changed, 6 deletions(-)

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
1.7.11

