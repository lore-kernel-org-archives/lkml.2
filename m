Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0DVWaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:30:06 -0400
Received: from kroah.org ([198.145.64.141]:56349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0DVW3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:29:37 -0400
Date: Thu, 22 Apr 2010 15:29:28 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.34-git
Message-ID: <20100422222928.GA3268@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 patches for your 2.6.34-git tree.

Two documentation updates, and one fix for the sysfs attribute warning
that people have reported.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/HOWTO                   |    2 +-
 Documentation/stable_kernel_rules.txt |    9 ++++-----
 drivers/hwmon/asus_atk0110.c          |    4 ++++
 3 files changed, 9 insertions(+), 6 deletions(-)

---------------

Jiri Kosina (1):
      sysfs: use sysfs_attr_init in ASUS atk0110 driver

Randy Dunlap (1):
      Documentation/HOWTO: update git home URL

Stefan Richter (1):
      Documentation: -stable rules: upstream commit ID requirement reworded

