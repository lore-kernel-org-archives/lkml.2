Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0GZTLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:11:42 -0400
Received: from kroah.org ([198.145.64.141]:55393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab0GZTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:11:38 -0400
Date: Mon, 26 Jul 2010 12:09:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for .35-git
Message-ID: <20100726190905.GC12683@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 3 sysfs bugfixes for your .35-rc git tree.  These all fix up
regressions that people have reported due to the network namespace
changes to sysfs for the .35 release.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 fs/sysfs/symlink.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

---------------

Eric W. Biederman (3):
      sysfs: Don't allow the creation of symlinks we can't remove
      sysfs: sysfs_delete_link handle symlinks from untagged to tagged directories.
      sysfs: allow creating symlinks from untagged to tagged directories

