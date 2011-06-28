Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab1F1Pmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:42:53 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40638 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab1F1Pjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:39:55 -0400
X-Sasl-enc: FNL0TBc7krG5xk/8GAnpXrJEmmxJRvUS+4v24iaUJRkh 1309275594
Date: Tue, 28 Jun 2011 08:39:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 3.0
Message-ID: <20110628153911.GD32710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some driver core, and other driver-core related fixes for your
3.0 git tree.

Just a few minor fixes for things that people have reported, the
connector and platform.c ones being the biggest one that has hit people
recently.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/ driver-core-linus

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/base/platform.c         |    2 +-
 drivers/connector/connector.c   |    1 +
 drivers/firmware/google/Kconfig |    1 +
 drivers/misc/pti.c              |   11 +++++++----
 drivers/misc/ti-st/st_core.c    |    2 +-
 drivers/misc/ti-st/st_kim.c     |    8 ++++++--
 include/linux/connector.h       |    2 +-
 7 files changed, 18 insertions(+), 9 deletions(-)

---------------

Andrew Morton (1):
      drivers/base/platform.c: don't mark platform_device_register_resndata() as __init_or_module

J Freyensee (3):
      pti: double-free security PTI fix
      pti: ENXIO error case memory leak PTI fix.
      pti: PTI semantics fix in pti_tty_cleanup.

K. Y. Srinivasan (2):
      Connector: Set the CN_NETLINK_USERS correctly
      Connector: Correctly set the error code in case of success when dispatching receive callbacks

Randy Dunlap (1):
      firmware: fix GOOGLE_SMI kconfig dependency warning

Shahar Lev (1):
      drivers:misc: ti-st: fix skipping of change remote baud

Steven Rostedt (1):
      st_kim: Handle case of no device found for ID 0

