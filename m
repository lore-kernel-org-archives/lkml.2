Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0IDCKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:10:44 -0400
Received: from kroah.org ([198.145.64.141]:48484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0IDCKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:10:08 -0400
Date: Fri, 3 Sep 2010 19:09:43 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.36-git
Message-ID: <20100904020943.GB28645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB bugfixes and new device ids for your 2.6.36-git
tree.

The biggest is just fixing up some of the option device ids, everything
else is tiny compared to that.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/atm/cxacru.c          |   24 +++++++-
 drivers/usb/class/cdc-acm.c       |   23 +++++++-
 drivers/usb/core/message.c        |   22 ++++----
 drivers/usb/gadget/rndis.c        |   12 +++-
 drivers/usb/gadget/rndis.h        |    2 +-
 drivers/usb/gadget/s3c-hsotg.c    |    2 -
 drivers/usb/host/ehci-ppc-of.c    |   12 ++--
 drivers/usb/serial/cp210x.c       |   11 ++-
 drivers/usb/serial/ftdi_sio.c     |    8 +++
 drivers/usb/serial/ftdi_sio_ids.h |   12 ++++
 drivers/usb/serial/mos7840.c      |   32 +++++++---
 drivers/usb/serial/option.c       |  119 +++++++++++++++++++++++--------------
 drivers/usb/serial/ssu100.c       |    2 +-
 13 files changed, 196 insertions(+), 85 deletions(-)

---------------

A E Lawrence (1):
      USB: cp210x usb driver: add USB_DEVICE for Pirelli DP-L10 mobile.

Bill Pemberton (1):
      USB: ssu100: turn off debug flag

Craig Shelley (1):
      USB: CP210x Add new device ID

Dan Carpenter (1):
      USB: ehci-ppc-of: problems in unwind

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.

Dirk De Schepper (1):
      USB: option: fix incorrect novatel entries

Henrik Kretzschmar (1):
      USB: rndis: section mismatch fix

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Maurus Cuelenaere (1):
      USB: s3c-hsotg: Remove DEBUG define

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Simon Arlott (1):
      USB: cxacru: Use a bulk/int URB to access the command endpoint

Thadeu Lima de Souza Cascardo (1):
      usb: allow drivers to use allocated bandwidth until unbound

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.

