Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1BVX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:27:09 -0500
Received: from kroah.org ([198.145.64.141]:47788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1BVX1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:27:07 -0500
Date: Tue, 22 Feb 2011 15:27:03 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .38
Message-ID: <20110222232703.GA18987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your .38 tree.

Nothing major, new device ids and bugfixes.  The USB 3.0 fix was
applied, and then reverted at the request of Sarah, as she will be
submitting a better fix later on.

Another round of tiny musb fixes, and other driver fixes and device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/quirks.c     |    8 ++++++++
 drivers/usb/musb/musb_core.h  |   17 +++++++++--------
 drivers/usb/musb/omap2430.c   |    1 +
 drivers/usb/serial/sierra.c   |    3 +++
 drivers/usb/serial/usb_wwan.c |   15 +++++++++------
 drivers/usb/serial/visor.c    |   12 ++++++++++++
 6 files changed, 42 insertions(+), 14 deletions(-)

---------------

Alan Stern (1):
      USB: add quirks entry for Keytouch QWERTY Panel

Felipe Balbi (1):
      usb: musb: fix build breakage

Greg Kroah-Hartman (1):
      Revert "USB: Reset USB 3.0 devices on (re)discovery"

Jiri Slaby (1):
      USB: serial/usb_wwan, fix tty NULL dereference

Johan Hovold (2):
      usb: musb: omap2430: fix kernel panic on reboot
      USB: musb: omap2430: fix kernel panic on reboot

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Luben Tuikov (1):
      USB: Reset USB 3.0 devices on (re)discovery

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

