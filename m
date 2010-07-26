Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0GZTL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:11:58 -0400
Received: from kroah.org ([198.145.64.141]:55390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab0GZTLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:11:37 -0400
Date: Mon, 26 Jul 2010 12:09:00 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] serial fix for .35-git
Message-ID: <20100726190900.GB12683@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a single bugfix for the atmel_serial serial driver that is for
your .35-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

This patch has been in the linux-next tree and -mm tree for a while.

The patch will be sent to the linux-kernel mailing list, if anyone wants
to see it.

thanks,

greg k-h

------------

 arch/avr32/include/asm/ioctls.h             |    3 +++
 arch/avr32/mach-at32ap/include/mach/board.h |    2 ++
 drivers/serial/atmel_serial.c               |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

---------------

Peter Huewe (1):
      serial: fix rs485 for atmel_serial on avr32

