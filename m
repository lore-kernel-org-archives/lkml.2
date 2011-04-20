Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1DTFFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 01:05:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:41734 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1DTFFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 01:05:18 -0400
Date: Tue, 19 Apr 2011 22:06:17 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
Message-ID: <20110420050617.GA16756@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
 <1303263653.3464.65.camel@localhost>
 <20110420020128.GA27631@suse.de>
 <1303265862.3464.77.camel@localhost>
 <20110420031105.GA11945@suse.de>
 <1303274910.3464.95.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303274910.3464.95.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 05:48:30AM +0100, Ben Hutchings wrote:
> On Tue, 2011-04-19 at 20:11 -0700, Greg KH wrote:
> > On Wed, Apr 20, 2011 at 03:17:42AM +0100, Ben Hutchings wrote:
> > > On Tue, 2011-04-19 at 19:01 -0700, Greg KH wrote:
> > > > On Wed, Apr 20, 2011 at 02:40:53AM +0100, Ben Hutchings wrote:
> > > > > On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> > > > > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > > > > 
> > > > > > ------------------
> > > > > > 
> > > > > > From: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > > > > > 
> > > > > > commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
> > > > > > 
> > > > > > Remove check_c1e_idle() and use the new AMD errata checking framework
> > > > > > instead.
> > > > > 
> > > > > Clean-up patches are generally not candidates for longterm updates.
> > > > 
> > > > This was added because a follow-on patch required it.
> > > 
> > > Ah yes, 'x86, AMD: Set ARAT feature on AMD processors' is using the same
> > > condition.
> > > 
> > > Of course, that could have been backported by referring to the function
> > > that this removes, rather than pulling in a load of other changes with
> > > consequent risk of regressions.
> > 
> > I prefer to take original patches for stable, it makes it easier in the
> > end.
> 
> It makes what easier, when?  What I see here is a bug fix that is much
> larger than necessary, with a consequent risk of regression that seems
> way out of proportion to the benefit.  (What actually *is* the benefit
> of these AMD changes?)  And we have had several serious regressions in
> the 2.6.32.y series recently, so I really don't think we are getting the
> trade-off right.

We got a few new quirks added for AMD hardware platforms that fix
problems.  It took 3 patches to get there, yes, but now, as time goes
on, adding new ones is even easier as the .32 code matches the .39 code
in this area due to these patches being added.

Now if you find problems in these, great, let me know and I will work to
resolve them.

As for regressions, what are you referring to?

thanks,

greg k-h
