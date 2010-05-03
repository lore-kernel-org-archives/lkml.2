Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab0ECXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:41:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777Ab0ECXlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:41:44 -0400
Date: Mon, 3 May 2010 16:41:23 -0700
From: Greg KH <gregkh@suse.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Greg KH <greg@kroah.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100503234123.GC13519@suse.de>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
 <20100430215645.GA12409@kroah.com>
 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
 <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
 <20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 06:33:08PM -0500, H Hartley Sweeten wrote:
> On Monday, May 03, 2010 3:45 PM, H Hartley Sweeten wrote:
> >>> Could the next tree be out of sync with your tree?
> >>
> >> Hm, some other tree might be doing something in those files.  But the
> >> fact that the drivers/staging/dt3155/dt3155_io.h was so wrong it thought
> >> it was a revert, makes me suspect that you did it against something
> >> else.
> >>
> >> If you make this against my staging-next tree at
> >> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> >> Using the staging-next branch, does that make the patch different?
> >
> > Ok.  Pulled your staging-next (thanks Joe).
> >
> > It's way different from linux-next and matches Linus' tree exactly.  It's
> > missing all of your "Drop the "_s"..." and "The typedef is not needed." 
> > patches.
> >
> > Of course I could be on the wrong branch for your staging-next tree.  The
> > only branches listed are:
> >
> > $ git branch -a
> > * master
> >   remotes/origin/HEAD -> origin/master
> >   remotes/origin/master
> 
> It appears these are the patches missing in your staging-next tree that do
> exist in the linux-next tree:
> 
> Staging: dt3155: remove "inline" usage
> Staging: dt3155: rename dt3155_fbuffer_s
> Staging: dt3155: rename dt3155_config_s
> Staging: dt3155: rename dt3155_read_t
> Staging: dt3155: rename dt3155_status_t
> Staging: dt3155: remove frame_info_t
> Staging: dt3155: remove TRUE/FALSE
> Staging: dt3155: remove #ifdef
> Staging: dt3155: allocator.c: sparse cleanups
> Staging: dt3155: fix parentheses and bracket spacing style issues
> Staging: dt3155: fix coding style issue in dt3155_isr.c
> Staging: dt3155: fix wait_ibsyclr function
> Staging: remove unused #include <linux/version.h>

No, wait, I see these in my staging-next tree here.  Some of them I
wrote :)

Are you sure you are cloning my tree properly?

confused,

greg k-h
