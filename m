Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0ITXmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:42:50 -0400
Received: from kroah.org ([198.145.64.141]:42676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0ITXmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:42:49 -0400
Date: Mon, 20 Sep 2010 16:42:04 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .36-rc6
Message-ID: <20100920234204.GA7672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some usb driver fixes for .36-rc6.

A MAINTAINERS file update, and some other bugfixes that people have made
for problems reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 MAINTAINERS                     |    4 +-
 drivers/usb/host/ehci-pci.c     |    5 ++
 drivers/usb/musb/musb_debugfs.c |    5 +-
 drivers/usb/otg/twl4030-usb.c   |   78 +++++++++++++++++++++++++-------------
 drivers/usb/serial/mos7720.c    |    3 +
 drivers/usb/serial/mos7840.c    |    3 +
 6 files changed, 66 insertions(+), 32 deletions(-)

---------------

Alek Du (1):
      USB: EHCI: Disable langwell/penwell LPM capability

Dan Rosenberg (1):
      USB: serial/mos*: prevent reading uninitialized stack memory

Felipe Balbi (1):
      USB: musb: MAINTAINERS: Fix my mail address

Mathias Nyman (1):
      usb: musb_debugfs: don't use the struct file private_data field with seq_files

Ming Lei (1):
      USB: otg: twl4030: fix phy initialization(v1)

