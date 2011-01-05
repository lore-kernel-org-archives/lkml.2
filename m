Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1AEX71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:59:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:51969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1AEX7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:59:25 -0500
Date: Wed, 5 Jan 2011 15:57:48 -0800
From: Greg KH <gregkh@suse.de>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] staging: tidspbridge for 2.6.38
Message-ID: <20110105235748.GB22850@suse.de>
References: <1293178543-7556-1-git-send-email-omar.ramirez@ti.com>
 <20110105211847.GA16229@kroah.com>
 <AANLkTikWpxq+35pLN_r6B214jcO2Ss2rEv0KA9bcMJFL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikWpxq+35pLN_r6B214jcO2Ss2rEv0KA9bcMJFL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 05:47:47PM -0600, Ramirez Luna, Omar wrote:
> On Wed, Jan 5, 2011 at 3:18 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Dec 24, 2010 at 02:15:43AM -0600, Omar Ramirez Luna wrote:
> >> Hi Greg,
> >>
> >> This is the first pull request of changes for tidspbridge driver for 2.6.38,
> >> I expect to make another request with at least one bug fix, but in the mean
> >> time here it is the content for this one:
> >>
> >> The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:
> >>
> >>   Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)
> >>
> >> are available in the git repository at:
> >>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git dspbridge
> >
> > Ick, no.  Why did you base this on -rc7?  My staging-next branch is
> > based on -rc5 at the moment, and I really see no need to merge the rest
> > of them into the tree for no good reason at all.
> 
> wrongly though staging-next would be at rc7+ at the time you could
> take a look to the patches

Why would I want to sync it?  You can (and should) always go off of my
current staging-next tree if you are wanting me to take a git pull.
It's ok if it is an older version, fast-forwards are just fine.

> > Also, as you did send this before the merge window closed, but during
> > the holidays, I couldn't get to it.  But in looking at this, it's going
> > to have to wait for the next window, sorry, it's just too big, and too
> > late.  You weren't expecting me to be working on kernel stuff during my
> > holiday break, were you?
> 
> No I wasn't :)
> 
> > So, feel free to redo this against 2.6.38-rc1 when that comes out.
> 
> No problem then, but could you consider a 2nd pull with a compilation
> fix (which will be introduced in 2.6.38, right now present in
> linux-next), and a bug fix.

I'll always take patches for bugfixes, but please wait for after I sync
my current tree with Linus before I can do anything with it.

thanks,

greg k-h
