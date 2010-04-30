Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab0D3TSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:18:24 -0400
Received: from kroah.org ([198.145.64.141]:53037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab0D3Qxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:42 -0400
Date: Fri, 30 Apr 2010 09:36:54 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.34-git
Message-ID: <20100430163654.GB16424@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 bugfixes and one new device id for your 2.6.34-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/isicom.c       |    9 +++++++--
 drivers/char/istallion.c    |    2 ++
 drivers/char/mxser.c        |    3 ++-
 drivers/char/riscom8.c      |    1 +
 drivers/char/stallion.c     |    7 ++++---
 drivers/serial/8250_pnp.c   |    2 ++
 drivers/serial/pmac_zilog.c |    4 +++-
 7 files changed, 21 insertions(+), 7 deletions(-)

---------------

Alan Cox (1):
      tty: Fix regressions in the char driver conversion

Julia Lawall (1):
      serial: drivers/serial/pmac_zilog.c: add missing unlock

Ping Cheng (1):
      serial: 8250_pnp - add Fujitsu Wacom device

