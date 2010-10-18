Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0JRUNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:13:30 -0400
Received: from fifo99.com ([67.223.236.141]:45356 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab0JRUN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:13:29 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <20101018110207.131b56ee.sfr@canb.auug.org.au>
	 <20101018081520.GA10551@flint.arm.linux.org.uk>
	 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
	 <20101018182044.GA558@flint.arm.linux.org.uk>
	 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 13:12:54 -0700
Message-ID: <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 15:29 -0400, Nicolas Pitre wrote:

> > Ok, well in that case why not accept this immediately after the merge
> > window? A point when everything is quiet, and most of the tree's are
> > empty?
> 
> RMK has his own merge window which closes about at the same time as 
> Linus' one opens.  We thought this was happening last week and therefore 
> this change was supposed to be the last one.

It seems like that could potentially make these kinds of problem worse,
since your merging things immediately before sending them to Linus. Like
right now we only have a fairly short amount of time to correct this
conflict. 

> > Well how about I merge this change into my tree ?
> 
> If you ask RMK to merge your tree in his that would be much simpler to 
> add this change in a single pass afterwards.

I can do that , but would I still be able to merge stuff into my tree?
Seems like I could, Russell would just clean up the conflict and my tree
would just move forward like it has been already , and I would send the
whole thing to Linus.

Daniel


