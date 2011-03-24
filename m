Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1CXQaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:30:14 -0400
Received: from kroah.org ([198.145.64.141]:51521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1CXQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:30:09 -0400
Date: Thu, 24 Mar 2011 09:30:04 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .39
Message-ID: <20110324163004.GA22082@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some small fixes for the USB tree for things that people have
reported during the .39-rc1 merge window.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c    |    7 ++++++-
 drivers/usb/class/cdc-wdm.c    |    2 +-
 drivers/usb/core/devio.c       |    2 +-
 drivers/usb/host/ehci-q.c      |   12 ------------
 drivers/usb/misc/uss720.c      |    7 +++----
 drivers/usb/musb/blackfin.c    |    6 +++---
 drivers/usb/musb/musb_gadget.c |    8 ++++----
 drivers/usb/serial/usb_wwan.c  |    3 +--
 8 files changed, 19 insertions(+), 28 deletions(-)

---------------

Alan Stern (1):
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Bob Liu (1):
      usb: musb: blackfin: fix typo in new dev_pm_ops struct

Hema HK (1):
      usb: musb: Fix for merge issue

Johan Hovold (3):
      USB: cdc-acm: fix memory corruption / panic
      USB: cdc-acm: fix potential null-pointer dereference
      USB: cdc-acm: fix potential null-pointer dereference on disconnect

Michal Sojka (1):
      USB: Do not pass negative length to snoop_urb()

Mike Frysinger (2):
      usb: musb: blackfin: fix typo in platform driver name
      usb: musb: blackfin: fix typo in new bfin_musb_vbus_status func

Oliver Neukum (1):
      usb: wwan: fix compilation without CONFIG_PM_RUNTIME

Peter Holik (1):
      USB: uss720 fixup refcount position

Robert Lukassen (1):
      USB: Fix 'bad dma' problem on WDM device disconnect

