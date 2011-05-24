Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1EXWSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:18:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab1EXWSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:18:15 -0400
Date: Tue, 24 May 2011 15:13:00 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
Message-ID: <20110524221300.GA25828@suse.de>
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
 <4DDB960F.4050902@monstr.eu>
 <20110524123625.GC31517@suse.de>
 <20110524150215.GA2723@local>
 <20110524151413.GA25076@suse.de>
 <20110524220408.GB16040@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524220408.GB16040@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 12:04:08AM +0200, Hans J. Koch wrote:
> On Tue, May 24, 2011 at 08:14:13AM -0700, Greg KH wrote:
> > On Tue, May 24, 2011 at 05:02:16PM +0200, Hans J. Koch wrote:
> > > On Tue, May 24, 2011 at 05:36:25AM -0700, Greg KH wrote:
> > > > On Tue, May 24, 2011 at 01:27:11PM +0200, Michal Simek wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > can you please add it to your tree? I see you have sent pull request.
> > > > 
> > > > It's too late for the merge window for this, sorry.  I needed to have
> > > > this before it opened up, and in the linux-next tree for a week or so
> > > > before that.
> > > > 
> > > > Sorry.
> > > > 
> > > > Can you resend it in a format that I can apply it in, as well as getting
> > > > an ack from Hans?
> > > 
> > > There was already a "Signed-off-by:" from me, and a "Reviewed-by:" from
> > > Wolfram Sang, so that should be OK.
> > 
> > There was on the forwarded patch?  Sorry, I missed it, if only it was in
> > a format that could have been applied :)
> 
> I forwarded the original patch (added Signed-of-by and Reviewed-by tags)
> to you.

Thanks, I'll queue it up for the next major merge window.

greg k-h
