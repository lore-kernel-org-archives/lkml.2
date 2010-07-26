Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0GZTLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:11:38 -0400
Received: from kroah.org ([198.145.64.141]:55388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0GZTLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:11:36 -0400
Date: Mon, 26 Jul 2010 12:08:47 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.35-git
Message-ID: <20100726190847.GA12683@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB bugfixes for your 2.6.35-git tree.

Most of them are USB 3.0 (xhci) controller fixes for problems that
people have reported.  The rest of them are new device ids or minor
bugfixes that people have reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c         |    1 +
 drivers/usb/core/hub.c              |    2 ++
 drivers/usb/core/quirks.c           |    7 +++++++
 drivers/usb/gadget/s3c2410_udc.c    |    4 ++++
 drivers/usb/host/xhci-mem.c         |   26 ++++++++++++++++++++++++--
 drivers/usb/host/xhci-ring.c        |   11 +++++++----
 drivers/usb/host/xhci.c             |    2 ++
 drivers/usb/host/xhci.h             |    2 ++
 drivers/usb/misc/sisusbvga/sisusb.c |    5 +++--
 drivers/usb/musb/tusb6010.c         |   13 -------------
 drivers/usb/serial/ftdi_sio.c       |    9 +++++++++
 drivers/usb/serial/ftdi_sio_ids.h   |   15 +++++++++++++++
 drivers/usb/serial/option.c         |    4 ++++
 drivers/usb/serial/qcserial.c       |    2 ++
 drivers/usb/serial/sierra.c         |    1 +
 drivers/usb/storage/transport.c     |    4 +---
 16 files changed, 84 insertions(+), 24 deletions(-)

---------------

Andrew Bird (1):
      USB: New PIDs for Qualcomm gobi 2000 (qcserial)

Bob Copeland (1):
      USB: usb-storage: fix initializations of urb fields

Colin Leitner (1):
      USB: ftdi_sio: support for Signalyzer tools based on FTDI chips

Corey Minyard (1):
      USB: FTDI: Add support for the RT System VX-7 radio programming cable

Dennis Jansen (1):
      USB: option: Add support for AMOI Skypephone S2

Felipe Balbi (1):
      USB: musb: tusb6010: fix compile error with n8x0_defconfig

Oliver Neukum (2):
      USB: sisusbvga: Fix for USB 3.0
      USB: add quirk for Broadcom BT dongle

Paul Mortier (1):
      USB: adds Artisman USB dongle to list of quirky devices

Przemo Firszt (1):
      USB: Expose vendor-specific ACM channel on Nokia 5230

Sarah Sharp (4):
      USB: xHCI: Fix another bug in link TRB activation change.
      USB: Fix USB3.0 Port Speed Downgrade after port reset
      USB: xhci: Set EP0 dequeue ptr after reset of configured device.
      USB: xhci: Set Mult field in endpoint context correctly.

Vladimir Zapolskiy (1):
      USB: s3c2410_udc: be aware of connected gadget driver

august huber (1):
      USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c

Ömer Sezgin Ugurlu (1):
      USB: option: add support for 1da5:4518

