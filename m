Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab1GZFQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:16:01 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59714 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1GZFPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:15:54 -0400
X-Sasl-enc: Gycd61uZQdYiPMjBz1Ap3WIXttyQuHjX1BXZe5swdLQ0 1311657352
Date: Mon, 25 Jul 2011 21:57:07 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core merge for 3.1
Message-ID: <20110726045707.GA2321@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the "big" driver core merge for the 3.1 tree.

Not really much at all, mostly just documentation updates, and a few
other minor things.  Details are below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/ driver-core-next

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/driver-model/device.txt   |    2 +-
 Documentation/driver-model/overview.txt |   52 ++++--
 Documentation/filesystems/debugfs.txt   |    4 +-
 Documentation/ja_JP/SubmittingPatches   |  258 +++++++++++++++++++++++++------
 Documentation/zh_CN/email-clients.txt   |  210 +++++++++++++-------------
 drivers/base/Kconfig                    |   64 ++++----
 drivers/firmware/google/gsmi.c          |   19 ++-
 drivers/misc/pti.c                      |    6 +-
 drivers/uio/uio_pdrv_genirq.c           |   43 +++++
 9 files changed, 448 insertions(+), 210 deletions(-)

---------------

Akinobu Mita (1):
      debugfs: add documentation for debugfs_create_x64

Axel Lin (1):
      firmware: gsmi: remove sysfs entries when unload the module

Hans J. Koch (1):
      uio: uio_pdrv_genirq: Add OF support

Harry Wei (1):
      Documentation/zh_CN: Fix messy code file email-clients.txt

J Freyensee (1):
      pti: pti_tty_install documentation mispelling.

Keiichi Kii (1):
      updated Documentation/ja_JP/SubmittingPatches

Márton Németh (1):
      driver core: add more help description for "path to uevent helper"

Robert P. J. Day (2):
      DOCUMENTATION: Update overview.txt in Doc/driver-model.
      DOCUMENTATION: Replace create_device() with device_create().

matt mooney (2):
      driver-core: Kconfig grammar corrections in firmware configuration
      driver-core: modify FIRMWARE_IN_KERNEL help message

