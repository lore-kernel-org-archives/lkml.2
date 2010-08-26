Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0H0ACb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:02:31 -0400
Received: from kroah.org ([198.145.64.141]:54761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0H0AAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:41 -0400
Date: Thu, 26 Aug 2010 16:56:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.53
Message-ID: <20100826235645.GB13527@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826235552.GA13527@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.53 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                      |   14 +++++++++++---
 arch/arm/include/asm/ptrace.h |   17 +++++++++++++----
 drivers/gpu/drm/drm_drv.c     |    4 +++-
 drivers/usb/serial/io_ti.c    |    2 +-
 drivers/usb/serial/navman.c   |    1 +
 firmware/Makefile             |    2 +-
 net/can/bcm.c                 |   38 +++++++++++++++++++++++++-------------
 scripts/mkmakefile            |    4 +++-
 security/selinux/hooks.c      |    2 +-
 9 files changed, 59 insertions(+), 25 deletions(-)

Dave Airlie (1):
      drm: stop information leak of old kernel stack.

Greg Kroah-Hartman (2):
      USB: io_ti: check firmware version before updating
      Linux 2.6.27.53

Jan Beulich (1):
      fixes for using make 3.82

Oliver Hartkopp (1):
      can: add limit for nframes and clean up signed/unsigned variables

Ross Burton (1):
      USB: add device IDs for igotu to navman

Russell King (1):
      ARM: Tighten check for allowable CPSR values

Sam Ravnborg (1):
      kbuild: fix make incompatibility

Stephen Smalley (1):
      selinux: use default proc sid on symlinks

