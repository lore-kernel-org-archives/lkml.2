Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0JSQz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:55:59 -0400
Received: from fifo99.com ([67.223.236.141]:53345 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab0JSQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:55:55 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <alpine.LFD.2.00.1010182227440.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <20101018110207.131b56ee.sfr@canb.auug.org.au>
	 <20101018081520.GA10551@flint.arm.linux.org.uk>
	 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
	 <20101018182044.GA558@flint.arm.linux.org.uk>
	 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
	 <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
	 <20101018205847.GB23642@flint.arm.linux.org.uk>
	 <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
	 <20101018215815.GC23642@flint.arm.linux.org.uk>
	 <1287440826.5588.83.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
	 <1287443346.5588.120.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181923450.2764@xanadu.home>
	 <1287445545.5588.158.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010182227440.2764@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 09:55:16 -0700
Message-ID: <1287507316.10071.9.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 22:47 -0400, Nicolas Pitre wrote:
> On Mon, 18 Oct 2010, Daniel Walker wrote:
> 
> > I can say that I know for a fact that people don't read every patch, or
> > every email, or keep track of every single thread. I don't think it's
> > reasonable to expect people to do that. there's too many email, too many
> > threads, too many discussions etc ..
> 
> I'm not saying that you should keep track of every threads.  But you 
> should at least pay attention to what thread is being discussed, simply 
> by looking at the subject line.  Any good MUA will let you sort emails 
> and collapse them into thread view.  And scoring those incoming emails 
> with "arch/arm/mach-msm" for example is a quick way for you to be 
> noticed when a patch might be changing something in your area.  Tools 
> are there for you.

AFAIK before this thread, I should get CC'd when you modify me tree..
Maybe I'll setup some tools _now_ ..

> > This discussion isn't really about that. It's not about people reading
> > every single patch, which we know they don't do. This is about conflicts
> > in -next.
> 
> Glad to get back to the original issue.
> 
> > These patches caused conflicts in -next .. What more could I have done
> > to prevent conflicts coming from another tree and patches that appear
> > not to effect me? Even if I read all the patches, and threads, it still
> > seems unreasonable to expect maintainers to predict conflicts not coming
> > from their own tree's.
> 
> In this particular case, Stephen did fix the trivial merge conflict.  
> Most probably Linus could have done the same.  There is nothing you 
> needed to do in that case.  Or you could have waited until RMK's tree 
> hits mainline, then you merge that, fixing the issue within that merge, 
> before asking Linus to pull.
> 
> And if the merge in linux-next turned out not to be that trivial, or you 
> have new machine entries in your tree that failed to compile due to the 
> missing fixup, well that's fine too because that's _exactly_ what the 
> purpose of the linux-next tree is: finding issues like this before the 
> real merge in Linus' tree.  So in this case the system did work: the 
> conflict was identified by the tool and you were notified.
> 
> And the simplest solution to this is simply to merge your stuff into 
> RMK's tree in this case, so the generic change affecting all ARM 
> machines will cover yours as well.  Incidentally that's what has been 
> asked of you.
> 
> See?  Nothing to really get excited about.

Am I excited? Russell is the one getting excited .. I was the one trying
to correct the issues , so Linus doesn't have to deal with it.

Daniel


