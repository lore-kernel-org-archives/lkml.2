Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1JMAWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab1JMAWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:22:13 -0400
Date: Wed, 12 Oct 2011 18:12:02 -0600
From: Greg KH <gregkh@suse.de>
To: Aras Vaichas <arasv@magellan-technology.com>
Cc: Mihai Don??u <mihai.dontu@gmail.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
Message-ID: <20111013001202.GB19446@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
 <20100907212915.GB6798@suse.de>
 <201009080254.03070.mihai.dontu@gmail.com>
 <20100908003424.GA27719@suse.de>
 <CAPs5rNZ07VZ0qK2PVG2u1DLEEnXS_CvVcYGLLE7fzFCcMo696A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPs5rNZ07VZ0qK2PVG2u1DLEEnXS_CvVcYGLLE7fzFCcMo696A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:31:08AM +1100, Aras Vaichas wrote:
> On 8 September 2010 10:34, Greg KH <gregkh@suse.de> wrote:

You are responding to a message from over a year ago?

> > On Wed, Sep 08, 2010 at 02:54:02AM +0300, Mihai Don??u wrote:
> > > On Wednesday 08 September 2010 00:29:15 Greg KH wrote:
> > > > On Tue, Sep 07, 2010 at 04:18:23PM +0530, Gadiyar, Anand wrote:
> > > > > Since Greg has already sent a pull request, I won't touch the file
> > > > > now; maybe a trivial patch later on to fix up the coding style.
> > > >
> > > > That would be fine to have, I'd gladly accept it.
> > >
> > > Would something like the following do? It's against:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> > >
> > > Corrected the coding style.
> >
> > Looks good, thanks, I'll go queue it up.
> 
> Did this patch get applied and the problem resolved?

Probably, I'd suggest you take a look at the kernel sources to verify
this, I can't remember what was applied last week very well, let alone
last year.

> I'm running 2.6.33.7-rt29 and we have a customer in India who
> complains that they can't connect via USB. We don't have the problem
> here, or anywhere else that we know of.
> 
> I looked at the logs of the device and it appears to have the same
> Oops error as the one that this patch addresses.

What kernel version are they using?  Hopefully something newer than the
date of this original email :)

greg k-h
