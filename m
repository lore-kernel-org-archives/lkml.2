Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1BJUPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:15:49 -0500
Received: from kroah.org ([198.145.64.141]:40787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1BJUPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:15:48 -0500
Date: Thu, 10 Feb 2011 12:15:20 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver fixes for .38
Message-ID: <20110210201520.GA18283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few tty and serial fixes for your .38 tree.

A file got moved back that shouldn't have been moved in the tty/hvc
renames, and a few other tiny bugfixes, nothing major.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these patches have been in the -mm and -next trees for the past
week or so.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 arch/blackfin/include/asm/bfin_serial.h    |    2 ++
 drivers/char/Makefile                      |    1 +
 drivers/{tty/hvc => char}/virtio_console.c |    2 +-
 drivers/tty/hvc/Makefile                   |    1 -
 drivers/tty/n_gsm.c                        |    1 +
 drivers/tty/serial/68360serial.c           |    1 +
 drivers/tty/serial/bfin_5xx.c              |   15 ++++++---------
 7 files changed, 12 insertions(+), 11 deletions(-)
 rename drivers/{tty/hvc => char}/virtio_console.c (99%)

---------------

Amit Shah (1):
      virtio: console: Move file back to drivers/char/

Ben Hutchings (1):
      68360serial: Plumb in rs_360_get_icount()

Ken Mills (1):
      n_gsm: copy mtu over when configuring via ioctl interface

Sonic Zhang (1):
      serial: bfin_5xx: split uart RX lock from uart port lock to avoid deadlock

