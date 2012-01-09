Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2AITJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:09:31 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52140 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab2AITJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:09:30 -0500
X-Sasl-enc: lOhy398R0JmnrZMyHKzr4GSHoE8I3eetbiQPB/kRNC07 1326136169
Date: Mon, 9 Jan 2012 11:07:36 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char and misc patches for 3.3
Message-ID: <20120109190736.GA9440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the char/misc patches for the 3.3 merge.

Not much here at all, just some minor driver updates, and a few
cleanups.  Nothing exciting overall.

Please pull from:
	git.kernel.org:/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-next

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/misc/ad525x_dpot-i2c.c |   10 +---
 drivers/misc/ad525x_dpot-spi.c |   97 ++++++++++++++++------------------------
 drivers/misc/ad525x_dpot.c     |   24 +++++-----
 drivers/misc/ad525x_dpot.h     |    8 +---
 drivers/misc/bmp085.c          |    2 +-
 drivers/misc/isl29020.c        |    2 +-
 drivers/misc/ti-st/st_core.c   |   18 ++++++--
 drivers/misc/ti-st/st_kim.c    |   84 ++++++++++++++++++++++------------
 drivers/s390/char/tape_class.h |    1 -
 fs/char_dev.c                  |    6 +-
 10 files changed, 126 insertions(+), 126 deletions(-)

---------------

Greg Kroah-Hartman (2):
      s390: tape_class.h: remove kobj_map.h inclusion
      char_dev.c: fix up some whitespace errors

Jesper Juhl (2):
      BMP085: Remove redundant semi-colon from return statement
      isl29020: Remove a redundant semi-colon from return statement

Michael Hennerich (1):
      misc: ad525x_dpot: Add support for SPI module device table matching

Pavan Savoy (3):
      drivers:misc: ti-st: protect registrations
      drivers:misc: ti-st: flush UART upon fw failure
      drivers:misc: ti-st: DEBUG uart, baud rate mods

