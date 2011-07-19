Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1GSEYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:24:53 -0400
Received: from iabervon.org ([66.92.72.58]:46855 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1GSEYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:24:52 -0400
Date: Tue, 19 Jul 2011 00:16:59 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
In-Reply-To: <alpine.LNX.2.00.1107181231070.2056@iabervon.org>
Message-ID: <alpine.LNX.2.00.1107182358331.2056@iabervon.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org> <20110714135302.GA28501@thinkpad-t410> <alpine.LNX.2.00.1107141330370.2056@iabervon.org> <alpine.LNX.2.00.1107142116260.2056@iabervon.org> <20110715143900.GB19063@thinkpad-t410>
 <20110718133651.GA19552@thinkpad-t410> <alpine.LNX.2.00.1107181231070.2056@iabervon.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Daniel Barkalow wrote:

> On Mon, 18 Jul 2011, Seth Forshee wrote:
> 
> > On Fri, Jul 15, 2011 at 09:39:00AM -0500, Seth Forshee wrote:
> > > What I also see are GPFs in memory allocation code, which is what I
> > > believe others have seen with my patch, and so far I haven't seen those
> > > with the reversions. So I'm suspecting memory corruption, but I don't
> > > yet see where the corruption is coming form. I found one problem, but I
> > > don't suspect it's responsible for the GPFs.
> > 
> > I had some torture tests running over the weekend with the "one
> > problem" mentioned above fixed, which was a couple of kfrees that were
> > still using the old vhdr pointers. There were no oopses over a couple of
> > days of testing. I've posted a new build on the bug in launchpad in
> > hopes of getting some testing from those who were getting oopses quite
> > readily. The updated patch follows.
> 
> I should be able to try it this evening.

It seems to work. I connected and disconnected it a bunch of times (due to 
a somewhat flaky connector) and mounted it, wrote to it, had it disconnect 
itself, and mounted it and ejected it, and generated some memory load, and 
got no oopses. (Just to be clear, I was testing the 0001 and 0003 of the 
first attempt with the formerly-attached patch as 0002, replacing the 
original 0002.)

Tested-by: Daniel Barkalow <barkalow@iabervon.org>

	-Daniel
*This .sig left intentionally blank*
