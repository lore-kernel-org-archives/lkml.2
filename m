Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab1F1Pm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:42:29 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49354 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758970Ab1F1Pjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:39:51 -0400
X-Sasl-enc: 7DlEAoQ614lL5BZvL4Ak6KlOac5W+R41zaDzDCYLxBjS 1309275590
Date: Tue, 28 Jun 2011 08:38:47 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for 3.0
Message-ID: <20110628153847.GA32710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of minor staging driver fixes for your 3.0 tree.

These fixes resolve all of the build issues that people have reported
for non-x86 arches due to the fallout of removing the "Are you sure you
want to build the staging drivers" Kconfig patch that went into 3.0-rc3.

There's also a suspend/resume bugfix that has hit a number of users of
the mei driver as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/staging/brcm80211/Kconfig     |    2 ++
 drivers/staging/comedi/Kconfig        |   22 ++++++++++++++++++++++
 drivers/staging/iio/Kconfig           |    2 +-
 drivers/staging/iio/accel/adis16204.h |    2 +-
 drivers/staging/iio/accel/adis16209.h |    4 ++--
 drivers/staging/iio/gyro/adis16260.h  |    2 +-
 drivers/staging/iio/imu/adis16400.h   |    2 +-
 drivers/staging/mei/init.c            |    2 +-
 drivers/staging/mei/wd.c              |   13 +++++++++----
 9 files changed, 40 insertions(+), 11 deletions(-)

---------------

Geert Uytterhoeven (1):
      Staging: iio: Make IIO depend on GENERIC_HARDIRQS

Greg Kroah-Hartman (3):
      Staging: brcm80211: disable drivers for PPC platforms
      Staging: brcm80211: disable drivers except for X86 or MIPS platforms
      Staging: comedi: fix build breakages on some platforms

Ralf Baechle (1):
      Staging: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE

Randy Dunlap (2):
      Staging: fix more iio builds when IIO_RING_BUFFER is not enabled
      Staging: fix iio builds when IIO_RING_BUFFER is not enabled

Tomas Winkler (1):
      Staging: mei: fix suspend failure

