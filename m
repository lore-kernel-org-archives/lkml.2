Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1EDVIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:08:00 -0400
Received: from kroah.org ([198.145.64.141]:39017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab1EDVHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:07:51 -0400
Date: Wed, 4 May 2011 14:05:17 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .39
Message-ID: <20110504210517.GA3146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some more small fixes for your .39 tree.

Nothing major, just some small fixes for things that have been reported.

The omap regulator patch was unfortunately named, but it does fix a
problem that has been seen with that hardware that is needed to get it
to work properly.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these have been in the linux-next tree for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/mfd/omap-usb-host.c      |    9 +++------
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 drivers/usb/host/ehci-omap.c     |   20 ++++++++++++++++++++
 drivers/usb/host/isp1760-hcd.c   |    1 +
 drivers/usb/host/xhci-hub.c      |   19 +++++++++++++++++--
 drivers/usb/musb/musb_gadget.c   |    6 ++----
 drivers/usb/musb/omap2430.c      |    2 +-
 7 files changed, 45 insertions(+), 14 deletions(-)

---------------

Alan Stern (1):
      USB: fix regression in usbip by setting has_tt flag

Andiry Xu (1):
      xHCI: Clear PLC in xhci_bus_resume()

Arvid Brodin (1):
      usb/isp1760: Report correct urb status after unlink

Axel Lin (1):
      mfd: Fix usbhs_enable error handling

Jarkko Nikula (2):
      usb: musb: omap2430: Fix retention idle on musb peripheral only boards
      usb: musb: gadget: Fix out-of-sync runtime pm calls

Keshava Munegowda (1):
      omap:usb: add regulator support for EHCI

