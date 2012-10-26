Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2JZRTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:19:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:59956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab2JZRR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:17:59 -0400
Date: Fri, 26 Oct 2012 10:15:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.7-rc3
Message-ID: <20121026171525.GA11356@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.7-rc3

for you to fetch changes up to bf34be058158fd30622601346819d098dc5d623f:

  Documentation:Chinese translation of Documentation/arm64/memory.txt (2012-10-25 11:54:06 -0700)

----------------------------------------------------------------
Driver core fixes for 3.7-rc3

Here are a number of firmware core fixes for 3.7, and some other minor fixes.
And some documentation updates thrown in for good measure.

All have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Joe Perches (1):
      dynamic_debug: Remove unnecessary __used

Ming Lei (5):
      firmware loader: cancel uncache work before caching firmware
      firmware loader: fix one reqeust_firmware race
      firmware loader: let direct loading back on 'firmware_buf'
      firmware loader: sync firmware cache by async_synchronize_full_domain
      firmware loader: document kernel direct loading

Tekkaman Ninja (3):
      Documentation:Chinese translation of Documentation/IRQ.txt
      Documentation:Chinese translation of Documentation/arm64/booting.txt
      Documentation:Chinese translation of Documentation/arm64/memory.txt

 Documentation/firmware_class/README   |  26 +++++----
 Documentation/zh_CN/IRQ.txt           |  39 ++++++++++++++
 Documentation/zh_CN/arm64/booting.txt | 156 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/zh_CN/arm64/memory.txt  |  93 ++++++++++++++++++++++++++++++++
 drivers/base/firmware_class.c         | 266 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------
 fs/sysfs/dir.c                        |  16 +++---
 include/linux/dynamic_debug.h         |   2 +-
 7 files changed, 465 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/zh_CN/IRQ.txt
 create mode 100644 Documentation/zh_CN/arm64/booting.txt
 create mode 100644 Documentation/zh_CN/arm64/memory.txt
