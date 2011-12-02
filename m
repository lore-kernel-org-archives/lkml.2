Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1LBVLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:11:22 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42986 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab1LBVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:11:20 -0500
X-Sasl-enc: QBN/O5lKiaYLVwvdIsAeWI7CiaqP2svOR7ToVlYcliwO 1322860279
Date: Fri, 2 Dec 2011 13:11:01 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] more staging fixes for 3.2
Message-ID: <20111202211101.GA18222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right, I have been chuckling evilly here, but that's for the 3.3
merge, not for 3.2 :)

Here are a few minor fixes for the staging tree to be merged into your tree.

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-linus

All patches have been in the -next releases for a while now.

thanks,

greg k-h

--------------

 drivers/staging/comedi/comedi_fops.c         |   96 +++++++++++++++++++------
 drivers/staging/comedi/drivers/usbduxsigma.c |    7 +-
 drivers/staging/rts_pstor/rtsx.c             |    1 +
 drivers/staging/usbip/vhci_rx.c              |   10 ++-
 4 files changed, 84 insertions(+), 30 deletions(-)

---------------

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Bernd Porr (2):
      staging: comedi: usbduxsigma: Fixed wrong range for the analogue channel.
      staging: comedi: fix oops for USB DAQ devices.

Dan Carpenter (1):
      Staging: comedi: integer overflow in do_insnlist_ioctl()

Federico Vaga (2):
      Staging: comedi: fix mmap_count
      Staging: comedi: fix signal handling in read and write

Greg Kroah-Hartman (1):
      Revert "Staging: comedi: integer overflow in do_insnlist_ioctl()"

Xi Wang (1):
      Staging: comedi: fix integer overflow in do_insnlist_ioctl()

wwang (1):
      staging:rts_pstor:Complete scanning_done variable

