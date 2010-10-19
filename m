Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0JSCrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:47:21 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45418 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0JSCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:47:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Oct 2010 22:47:17 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287445545.5588.158.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010182227440.2764@xanadu.home>
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
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Daniel Walker wrote:

> I can say that I know for a fact that people don't read every patch, or
> every email, or keep track of every single thread. I don't think it's
> reasonable to expect people to do that. there's too many email, too many
> threads, too many discussions etc ..

I'm not saying that you should keep track of every threads.  But you 
should at least pay attention to what thread is being discussed, simply 
by looking at the subject line.  Any good MUA will let you sort emails 
and collapse them into thread view.  And scoring those incoming emails 
with "arch/arm/mach-msm" for example is a quick way for you to be 
noticed when a patch might be changing something in your area.  Tools 
are there for you.

> This discussion isn't really about that. It's not about people reading
> every single patch, which we know they don't do. This is about conflicts
> in -next.

Glad to get back to the original issue.

> These patches caused conflicts in -next .. What more could I have done
> to prevent conflicts coming from another tree and patches that appear
> not to effect me? Even if I read all the patches, and threads, it still
> seems unreasonable to expect maintainers to predict conflicts not coming
> from their own tree's.

In this particular case, Stephen did fix the trivial merge conflict.  
Most probably Linus could have done the same.  There is nothing you 
needed to do in that case.  Or you could have waited until RMK's tree 
hits mainline, then you merge that, fixing the issue within that merge, 
before asking Linus to pull.

And if the merge in linux-next turned out not to be that trivial, or you 
have new machine entries in your tree that failed to compile due to the 
missing fixup, well that's fine too because that's _exactly_ what the 
purpose of the linux-next tree is: finding issues like this before the 
real merge in Linus' tree.  So in this case the system did work: the 
conflict was identified by the tool and you were notified.

And the simplest solution to this is simply to merge your stuff into 
RMK's tree in this case, so the generic change affecting all ARM 
machines will cover yours as well.  Incidentally that's what has been 
asked of you.

See?  Nothing to really get excited about.


Nicolas
