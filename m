Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab1FWSjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:39:23 -0400
Received: from mail.perches.com ([173.55.12.10]:3171 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803Ab1FWSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:39:21 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial next 0/2] i before e except after c typos
Date: Thu, 23 Jun 2011 11:39:18 -0700
Message-Id: <cover.1308853652.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  treewide: Fix recieve/receive typos
  treewide: transciever/transceiver spelling fixes

 arch/arm/mach-pxa/include/mach/corgi.h        |    2 +-
 arch/arm/mach-pxa/include/mach/pxa27x-udc.h   |    4 +-
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 +-
 drivers/i2c/busses/i2c-highlander.c           |    2 +-
 drivers/mmc/host/vub300.c                     |    4 +-
 drivers/net/caif/caif_hsi.c                   |    2 +-
 drivers/net/eexpress.c                        |    2 +-
 drivers/net/irda/toim3232-sir.c               |    2 +-
 drivers/net/natsemi.c                         |    2 +-
 drivers/net/wan/lmc/lmc_var.h                 |    2 +-
 drivers/tty/serial/8250_pci.c                 |    2 +-
 drivers/usb/gadget/pxa27x_udc.h               |    4 +-
 drivers/usb/misc/ftdi-elan.c                  |   28 ++++++++++++------------
 drivers/usb/musb/musb_core.c                  |    2 +-
 drivers/usb/otg/isp1301_omap.c                |    4 +-
 include/scsi/osd_initiator.h                  |    2 +-
 sound/pci/ice1712/ice1712.c                   |    2 +-
 sound/soc/omap/ams-delta.c                    |    2 +-
 18 files changed, 35 insertions(+), 35 deletions(-)

-- 
1.7.6.rc1

