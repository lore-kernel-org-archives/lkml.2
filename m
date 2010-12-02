Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0LBUw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:52:26 -0500
Received: from kroah.org ([198.145.64.141]:60375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030Ab0LBUwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:52:18 -0500
Date: Thu, 2 Dec 2010 12:52:12 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for .37-rc4
Message-ID: <20101202205212.GA6130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some minor patches for the driver core for .37-rc4

Just minor documentation changes, no code changed anywhere.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/ driver-core-linus

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/driver-model/interface.txt |  129 ------------------------------
 MAINTAINERS                              |    2 +-
 drivers/uio/uio.c                        |    2 +-
 drivers/uio/uio_cif.c                    |    2 +-
 drivers/uio/uio_netx.c                   |    2 +-
 include/linux/cpu.h                      |    5 -
 include/linux/node.h                     |    5 -
 include/linux/uio_driver.h               |    2 +-
 8 files changed, 5 insertions(+), 144 deletions(-)
 delete mode 100644 Documentation/driver-model/interface.txt

---------------

Brandon Philips (1):
      driver core: prune docs about device_interface

Greg Kroah-Hartman (1):
      driver core: the development tree has switched to git

Hans J. Koch (1):
      uio: Change mail address of Hans J. Koch

