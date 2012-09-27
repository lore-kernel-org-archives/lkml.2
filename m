Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2I0QoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:44:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0QoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:44:11 -0400
Date: Thu, 27 Sep 2012 09:44:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PATCH] USB fixes for 3.6-rc7
Message-ID: <20120927164407.GA20305@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.6-rc7

for you to fetch changes up to 0d00dc2611abbe6ad244d50569c2ee82ce42846c:

  USB: Fix race condition when removing host controllers (2012-09-27 09:17:49 -0700)

----------------------------------------------------------------
USB fixes for 3.6-rc7

Here are two USB bugfixes for your 3.6-rc7 tree.

The OHCI fix has been reported a number of times and is a regression
from 3.5, and the patch that causes the regression was on the way to the
-stable trees before I was reminded (again) that this fix needed to get
to your tree soon.

The host controller bugfix was reported in older kernels as being pretty
easy to trigger, and has been tested by Red Hat and their customers.

Both have been in the usb-next branch in the -next tree for a while now,
I just cherry-picked them out to get to you in time for the 3.6 release.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: Fix race condition when removing host controllers

Joachim Eastwood (1):
      USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

 drivers/usb/core/devices.c   |    2 +-
 drivers/usb/core/hcd.c       |    6 ++----
 drivers/usb/host/ohci-at91.c |    3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)
