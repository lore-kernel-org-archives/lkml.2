Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab0LUEmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:42:10 -0500
Received: from kroah.org ([198.145.64.141]:44629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545Ab0LUEmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:42:09 -0500
Date: Mon, 20 Dec 2010 20:41:59 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .37-rc6
Message-ID: <20101221044159.GA11750@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of USB patches for your .37-rc6 tree.

Again, some xhci fixes, and some other minor things.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/Kconfig           |   12 ++++++++++--
 drivers/usb/gadget/composite.c     |   18 +++++++++---------
 drivers/usb/host/xhci-mem.c        |   25 +++++++++++++++----------
 drivers/usb/misc/uss720.c          |    4 +++-
 drivers/usb/serial/ftdi_sio.c      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h  |    5 +++++
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 7 files changed, 50 insertions(+), 22 deletions(-)

---------------

Florian Faber (1):
      USB: ftdi_sio: Add D.O.Tec PID

Greg Kroah-Hartman (1):
      Revert "USB: gadget: Allow function access to device ID data during bind()"

Pavankumar Kondeti (2):
      USB: core: Add input prompt and help text for USB_OTG config
      USB: gadget: Remove suspended sysfs file before freeing cdev

Sarah Sharp (1):
      xhci: Fix issue with port array setup and buggy hosts.

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

