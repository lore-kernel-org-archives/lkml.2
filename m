Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0DVW3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:29:38 -0400
Received: from kroah.org ([198.145.64.141]:56341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0DVW3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:29:36 -0400
Date: Thu, 22 Apr 2010 15:26:10 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.34-git
Message-ID: <20100422222610.GA3187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB bugfixes and new device ids for your 2.6.34-git
tree.

Nothing really huge, just a bunch of needed fixes for reported problems.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/driver.c             |   49 ++++++++++++++++++++++++++++-----
 drivers/usb/host/ehci-hcd.c           |    1 +
 drivers/usb/host/ehci-hub.c           |    2 +-
 drivers/usb/host/ehci-mem.c           |    2 +-
 drivers/usb/host/ehci-omap.c          |    6 +++-
 drivers/usb/host/ehci-sched.c         |   40 +++++++++++++++++++++------
 drivers/usb/host/ehci.h               |    5 ++-
 drivers/usb/host/ohci-da8xx.c         |    2 +-
 drivers/usb/misc/usbsevseg.c          |   15 +++++++++-
 drivers/usb/serial/pl2303.c           |    1 +
 drivers/usb/serial/pl2303.h           |    4 +++
 drivers/usb/serial/qcaux.c            |   10 +++++++
 drivers/usb/serial/sierra.c           |    1 +
 drivers/usb/serial/ti_usb_3410_5052.c |   26 +++++++++++++++---
 drivers/usb/serial/ti_usb_3410_5052.h |    3 ++
 drivers/usb/wusbcore/devconnect.c     |    2 +-
 16 files changed, 139 insertions(+), 30 deletions(-)

---------------

Ajay Kumar Gupta (1):
      USB: ehci: omap: fix kernel panic with rmmod

Alan Stern (3):
      USB: fix remote wakeup settings during system sleep
      USB: EHCI: defer reclamation of siTDs
      USB: put claimed interfaces in the "suspended" state

Alex Manoussakis (1):
      USB: ti_usb_3410_5052: adding multitech dialup fax/modem devices

Dan Williams (1):
      USB: qcaux: add LG Rumor and Sanyo Katana LX device IDs

David Vrabel (1):
      usb: wusb: don't overflow the Keep Alive IE buffer

Dinh Nguyen (1):
      usb: Increase timeout value for device reset

Harrison Metzger (1):
      USB: fixed bug in usbsevseg using USB autosuspend incorrectly

Manuel Jander (1):
      USB: pl2303: add AdLink ND-6530 USB IDs

Sergei Shtylyov (1):
      USB: OHCI: DA8xx/OMAP-L1x: fix up macro rename

William Lightning (1):
      USB: Add id for HP ev2210 a.k.a Sierra MC5725 miniPCI-e Cell Modem.

