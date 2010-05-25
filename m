Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0EYWQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:16:06 -0400
Received: from kroah.org ([198.145.64.141]:38072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0EYWQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:16:05 -0400
Date: Tue, 25 May 2010 15:15:46 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] another driver core patch for .35
Message-ID: <20100525221546.GA29511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's one more driver core patch for the .35 merge window.

It provides the ability for module-init-tools to know which modules to
load when a user asks for a device node that is not present in the
system yet by exporting the information in the modules.

It also moves some misc devices from a dynamic number to a static one as
they are getting popular on a lot of systems.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

This patch has been in the linux-next and mm trees.

The patch will be sent as a follow-on to this message to lkml for people
to see, but it's already been sent there a number of times, so it's
nothing new.

thanks,

greg k-h

------------

 Documentation/devices.txt        |    2 ++
 arch/x86/kernel/microcode_core.c |    1 +
 drivers/net/ppp_generic.c        |    4 ++--
 drivers/net/tun.c                |    1 +
 fs/autofs4/dev-ioctl.c           |    5 ++++-
 fs/btrfs/super.c                 |    5 ++++-
 fs/fuse/dev.c                    |    1 +
 include/linux/miscdevice.h       |    2 ++
 8 files changed, 17 insertions(+), 4 deletions(-)

---------------

Kay Sievers (1):
      driver core: add devname module aliases to allow module on-demand auto-loading

