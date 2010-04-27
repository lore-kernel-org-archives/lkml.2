Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0D0Sns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:43:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:57981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0D0Snr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:43:47 -0400
Date: Tue, 27 Apr 2010 11:33:29 -0700
From: Greg KH <gregkh@suse.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/6] staging: push down BKL into ioctl functions
Message-ID: <20100427183329.GA525@suse.de>
References: <201004262112.39906.arnd@arndb.de>
 <1272320645-8671-5-git-send-email-arnd@arndb.de>
 <20100427181501.GC5586@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427181501.GC5586@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 08:15:07PM +0200, Frederic Weisbecker wrote:
> Hi Greg,
> 
> 
> On Tue, Apr 27, 2010 at 12:24:03AM +0200, Arnd Bergmann wrote:
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/staging/crystalhd/crystalhd_lnx.c |   13 +++++++++----
> >  drivers/staging/dt3155/dt3155_drv.c       |   24 ++++++++++++++++++------
> >  drivers/staging/poch/poch.c               |   17 +++++++++++++++--
> >  drivers/staging/vme/devices/vme_user.c    |   18 +++++++++++++++---
> >  4 files changed, 57 insertions(+), 15 deletions(-)
> 
> 
> If you are fine with this patch, I think it would be better if
> you get it in your tree.

Ok, I'll queue it up (note, the poch driver is now gone in the staging
tree.)

thanks,

greg k-h
