Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826Ab2DLWZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:25:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37787 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2DLWZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:25:41 -0400
Date: Thu, 12 Apr 2012 15:25:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 3.4-rc2
Message-ID: <20120412222537.GA11612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git tags/driver-core-3.4-rc2

for you to fetch changes up to 282029c005e65ffdce3aa9f8220f88a8bbbc4dae:

  kobject: provide more diagnostic info for kobject_add_internal() failures (2012-04-10 14:48:51 -0700)

----------------------------------------------------------------
Driver core and kobject fixes for 3.4-rc2

Here are some minor fixes for the driver core and kobjects that people have
reported recently.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      drivers/base: Remove unneeded spin_lock_init call for soc_lock

Bruno Prémont (1):
      sysfs: Prevent crash on unset sysfs group attributes

Dan Williams (2):
      sysfs: handle 'parent deleted before child added'
      kobject: provide more diagnostic info for kobject_add_internal() failures

Lee Jones (1):
      drivers/base: fix compiler warning in SoC export driver - idr should be ida

Tom Goff (1):
      sysfs: Update the name hash for an entry after changing the namespace

 drivers/base/soc.c |    4 +---
 fs/sysfs/dir.c     |    5 ++++-
 fs/sysfs/group.c   |    6 +++++-
 lib/kobject.c      |   14 +++++++-------
 4 files changed, 17 insertions(+), 12 deletions(-)
