Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0GESqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:46:10 -0400
Received: from kroah.org ([198.145.64.141]:35203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab0GESoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:14 -0400
Date: Mon, 5 Jul 2010 11:38:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.14
Message-ID: <20100705183812.GC31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.14 kernel.

There were a few security updates queued up for the .31 tree, and so I
just pushed them out for anyone unlucky enough to still be using a .31
kernel tree.  Please, move to the .32 kernel, as really, this is going
to be the last .31 kernel I contemplate releaseing, and I'm sure that I
haven't even gotten all of the known issues resolved with this release
either.

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 fs/reiserfs/dir.c         |    2 --
 fs/reiserfs/xattr.c       |   19 +++++--------------
 kernel/posix-timers.c     |   11 ++++-------
 sound/pci/mixart/mixart.c |   24 ++++++++++++++----------
 5 files changed, 24 insertions(+), 34 deletions(-)


Andrey Vagin (1):
      posix_timer: Fix error path in timer_create

Dan Carpenter (1):
      ALSA: mixart: range checking proc file

Greg Kroah-Hartman (1):
      Linux 2.6.31.14

Jeff Mahoney (2):
      reiserfs: fix permissions on .reiserfs_priv
      reiserfs: fix corruption during shrinking of xattrs

