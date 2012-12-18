Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab2LRRvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:51:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37916 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2LRRvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:51:20 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bernd Krumboeck <b.krumboeck@gmail.com>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v2 00/10] tx/rx LED trigger support
Date: Tue, 18 Dec 2012 18:50:54 +0100
Message-Id: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

this is the v2 of the canbus LED series.

Changes from v1:
- moved all framework patches before driver ones
- added usb_8dev driver patch to the series (based on v9 version)
- added by S-o-b to all patches in this series

The last usb_8dev patch requires Bernd's patch.  A part from this the
set applies cleanly on current mainline.

Thanks,
Fabio


Bernd Krumboeck (1):
  can: usb_8dev: add LED trigger support

Fabio Baltieri (7):
  can: add tx/rx LED trigger support
  can: flexcan: add LED trigger support
  can: at91_can: add LED trigger support
  can: ti_hecc: add LED trigger support
  can: c_can: add LED trigger support
  can: mcp251x: add LED trigger support
  can: sja1000: add LED trigger support

Kurt Van Dijck (2):
  can: export a safe netdev_priv wrapper for candev
  can: rename LED trigger name on netdev renames

 drivers/net/can/Kconfig           |  12 ++++
 drivers/net/can/Makefile          |   2 +
 drivers/net/can/at91_can.c        |  10 +++
 drivers/net/can/c_can/c_can.c     |  10 +++
 drivers/net/can/dev.c             |  18 ++++++
 drivers/net/can/flexcan.c         |  11 ++++
 drivers/net/can/led.c             | 129 ++++++++++++++++++++++++++++++++++++++
 drivers/net/can/mcp251x.c         |  23 +++++--
 drivers/net/can/sja1000/sja1000.c |  17 ++++-
 drivers/net/can/ti_hecc.c         |  10 +++
 drivers/net/can/usb/usb_8dev.c    |  11 ++++
 include/linux/can/dev.h           |  11 ++++
 include/linux/can/led.h           |  51 +++++++++++++++
 13 files changed, 310 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/can/led.c
 create mode 100644 include/linux/can/led.h

-- 
1.7.12.1

