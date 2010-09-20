Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0ITXnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:43:12 -0400
Received: from kroah.org ([198.145.64.141]:42678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab0ITXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:42:50 -0400
Date: Mon, 20 Sep 2010 16:42:09 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for .36-rc6
Message-ID: <20100920234209.GB7672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some serial driver bugfixes for the .36-rc6 kernel.

Minor stuff, but would be good to get included.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/serial/amba-pl010.c |    9 ++-------
 drivers/serial/mfd.c        |   17 +++++++++--------
 2 files changed, 11 insertions(+), 15 deletions(-)

---------------

Feng Tang (1):
      serial: mfd: fix bug in serial_hsu_remove()

Mika Westerberg (1):
      serial: amba-pl010: fix set_ldisc

