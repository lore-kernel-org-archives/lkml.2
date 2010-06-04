Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0FDVHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:07:25 -0400
Received: from kroah.org ([198.145.64.141]:42851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab0FDVHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:07:24 -0400
Date: Fri, 4 Jun 2010 14:07:10 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Rename ramzswap files to zram
Message-ID: <20100604210710.GA8163@kroah.com>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
 <1275379286-10453-3-git-send-email-ngupta@vflare.org>
 <20100604123246.3e11022e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604123246.3e11022e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 12:32:46PM -0700, Andrew Morton wrote:
> On Tue,  1 Jun 2010 13:31:24 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:
> 
> > Related changes:
> >  - Modify revelant Kconfig and Makefile accordingly.
> >  - Change include filenames in code.
> >  - Remove dependency on CONFIG_SWAP in Kconfig as zram usage
> > is no longer limited to swap disks.
> > 
> > Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> > ---
> >  drivers/staging/Kconfig                            |    2 +-
> >  drivers/staging/Makefile                           |    2 +-
> >  drivers/staging/ramzswap/Kconfig                   |   21 ---------------
> >  drivers/staging/ramzswap/Makefile                  |    3 --
> >  drivers/staging/zram/Kconfig                       |   28 ++++++++++++++++++++
> >  drivers/staging/zram/Makefile                      |    3 ++
> >  drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
> >  drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
> >  drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
> >  .../{ramzswap/ramzswap.txt => zram/zram.txt}       |    0
> >  .../{ramzswap/ramzswap_drv.c => zram/zram_drv.c}   |    2 +-
> >  .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |    2 +-
> >  .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |    0
> >  13 files changed, 35 insertions(+), 28 deletions(-)
> >  delete mode 100644 drivers/staging/ramzswap/Kconfig
> >  delete mode 100644 drivers/staging/ramzswap/Makefile
> >  create mode 100644 drivers/staging/zram/Kconfig
> >  create mode 100644 drivers/staging/zram/Makefile
> >  rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
> >  rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
> >  rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
> >  rename drivers/staging/{ramzswap/ramzswap.txt => zram/zram.txt} (100%)
> >  rename drivers/staging/{ramzswap/ramzswap_drv.c => zram/zram_drv.c} (99%)
> >  rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (99%)
> >  rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (100%)
> 
> This is a git-specific thing and doesn't do anything useful for people
> who use plain-old-patch(1) (eg: Greg and me).
> 
> Obviously we can manually type in the commands and put the massive
> file-moving diff together, but it's a bit of a pain.
> 
> Maybe Greg has some magic automated way of turning these into regular
> patches, but I don't.

No I don't :(

But for the staging tree, I've started to use git, so I should be able
to apply this.  I'll try it out next week when I get to the "here's
what's going into .36" series of patches sent to me.

thanks,

greg k-h
