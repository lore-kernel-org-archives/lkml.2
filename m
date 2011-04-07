Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1DGCzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:55:32 -0400
Received: from relais.videotron.ca ([24.201.245.36]:36492 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab1DGCzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:55:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 06 Apr 2011 22:55:30 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Eric Cooper <ecc@cmu.edu>
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
In-reply-to: <4D9CF5B3.9020007@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1104062228410.28032@xanadu.home>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
 <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
 <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
 <4D9CED15.2010806@ahsoftware.de>
 <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
 <4D9CF5B3.9020007@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Alexander Holler wrote:

> > > So I don't think this in any way a fragile hack.
> > 
> > Determining a machine type based on its amount of RAM is fragile, ugly
> > and sets up a bad example for even more hacky tricks like this to crop
> > up. If someone is experimenting with his SheevaPlug by giving different
> > memory information in the kernel cmdline e.g. to create memory holes in
> > order to test some memory allocator changes, then the kernel may think
> > that it is not running on a SheevaPlug but a DockStar, and the resulting
> > behavior will certainly be unexpected.
> 
> People doing such should now what they do. And the pr_info() in the
> "abomination" should be enough to give those experimenters a hint (if it is
> missing or new).

They shouldn't have to.  We have a well defined system to identify 
machines/platforms with a unique number already.  It is completely 
unambiguous.  What you're proposing is to break that system.

The proper way to go about this rationalization is to move that stuff 
over to device tree.

> > > Anyway, it was just a suggestion.
> > 
> > Better luck next time.
> 
> Sorry, I don't feel the need to waste my time prodcuing patches to get them
> called "abominations". Which means my willingness to post further patches just
> got below zero.

I'm sorry if you feel like that.  You shouldn't take this too personal.  
It is not like if I qualified _you_ as a moron and a pariah (yes this 
happened to me last week from our master penguin himself).


Nicolas
