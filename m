Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0HXEFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:05:35 -0400
Received: from kroah.org ([198.145.64.141]:39649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab0HXEFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:05:25 -0400
Date: Mon, 23 Aug 2010 21:05:03 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for .36-rc2
Message-ID: <20100824040503.GB16749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fixes for .36-rc2 for the driver core.

It fixes a firmware oops that a lot of people are hitting, and a build
error for older versions of gcc that it seems all of the ARM developers
are hitting.  And there's documentation fix as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/base/firmware_class.c |    2 +-
 include/linux/kobject.h       |   35 +-------------------------
 include/linux/kobject_ns.h    |   56 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h         |    1 +
 lib/kobject_uevent.c          |    4 +-
 5 files changed, 61 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/kobject_ns.h

---------------

David Howells (1):
      kobject: Break the kobject namespace defs into their own header

Johannes Berg (1):
      firmware_class: fix typo in error path

Xiaotian Feng (1):
      kobject_uevent: fix typo in comments

