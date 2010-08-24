Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0HXEFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:05:47 -0400
Received: from kroah.org ([198.145.64.141]:39652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab0HXEF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:05:27 -0400
Date: Mon, 23 Aug 2010 21:05:08 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for .36-rc2
Message-ID: <20100824040508.GC16749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tty and serial driver bugfixes for the .36-rc2 kernel.

Some fixes due to the BKL removal fallout, and other minor things.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/ip2/ip2main.c   |    4 +++-
 drivers/char/rocket.c        |    1 +
 drivers/char/synclink_gt.c   |    4 +++-
 drivers/serial/68328serial.c |   29 +++++++++++------------------
 drivers/serial/8250_early.c  |    4 ++--
 5 files changed, 20 insertions(+), 22 deletions(-)

---------------

Dan Carpenter (4):
      ip2: remove unneeded NULL check
      ip2: return -EFAULT on copy_to_user errors
      rocket: add a mutex_unlock()
      synclink: add mutex_unlock() on error path

Kulikov Vasiliy (1):
      68328serial: check return value of copy_*_user() instead of access_ok()

Tony Luck (1):
      serial: print early console device address in hex

