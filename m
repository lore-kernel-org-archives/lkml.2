Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab0JRWfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:35:14 -0400
Received: from relais.videotron.ca ([24.201.245.36]:50288 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0JRWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:35:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Oct 2010 18:35:11 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287440826.5588.83.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
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
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Daniel Walker wrote:

> On Mon, 2010-10-18 at 22:58 +0100, Russell King wrote:
> > On Mon, Oct 18, 2010 at 02:29:22PM -0700, Daniel Walker wrote:
> > > That's why we have get_maintainer.pl, it adds in all the CC's
> > > automatically ..
> > 
> > $ git diff-tree -u 861bd81ee62a0d6759144c22909a8a3938951656 | scripts/get_maintainer.pl |wc 
> >     209     624    8021
> > 
> > 209 recipients / 8K of To:/CC: is reasonable?
> 
> 
> The answer is not "The tool doesn't work like I want, so screw it." If
> the tool doesn't work like we want, then we need to fix the tool not
> just walk away. Not to mention that the people involved in making these
> patches should still be CC'ing people even if this tool is just helping
> them out instead of actually doing it for them.
> 
> What it's showing you is anyone that's ever modified those files.. You
> just need the people who maintain the files.
> 
> how about this,
> 
> git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl | wc
>      58     163    2169
> 
> That's the patch we're actually discussing too. It's about one CC per
> file modified.

What is a mailing list for, then?  Why are you subscribed?

Please get real or get away.


Nicolas
