Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0EMTQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:16:07 -0400
Received: from kroah.org ([198.145.64.141]:43895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab0EMTQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:16:03 -0400
Date: Thu, 13 May 2010 12:16:01 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.34-git
Message-ID: <20100513191601.GA17538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 bugfixes for your 2.6.34-git tree.

One is a regression from .33, and the other 2 fix reported problems and
are being sent to the -stable trees as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/tty_io.c         |    1 +
 drivers/serial/imx.c          |   10 +++++++++-
 drivers/serial/mpc52xx_uart.c |    2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

---------------

Alan Cox (1):
      tty: Fix unbalanced BKL handling in error path

Anatolij Gustschin (1):
      serial: mpc52xx_uart: fix null pointer dereference

Valentin Longchamp (1):
      serial: imx.c: fix CTS trigger level lower to avoid lost chars

