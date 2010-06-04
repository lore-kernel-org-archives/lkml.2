Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0FDUpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:45:51 -0400
Received: from kroah.org ([198.145.64.141]:43905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab0FDUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:45:04 -0400
Date: Fri, 4 Jun 2010 13:44:50 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for .35-git
Message-ID: <20100604204450.GC19761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 3 bugfixes for your .35-rc git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 fs/configfs/inode.c  |    9 ++++-----
 fs/sysfs/inode.c     |    6 ++++--
 lib/kobject_uevent.c |    3 +++
 3 files changed, 11 insertions(+), 7 deletions(-)

---------------

Andrew Morton (1):
      lib/kobject_uevent.c: fix CONIG_NET=n warning

Dan Carpenter (1):
      kobject: free memory if netlink_kernel_create() fails

Nick Piggin (1):
      fix setattr error handling in sysfs, configfs

