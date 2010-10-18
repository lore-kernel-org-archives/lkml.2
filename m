Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab0JRXcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:32:50 -0400
Received: from relais.videotron.ca ([24.201.245.36]:9821 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab0JRXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:32:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Oct 2010 19:32:48 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287443346.5588.120.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010181923450.2764@xanadu.home>
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
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Daniel Walker wrote:

> On Mon, 2010-10-18 at 18:35 -0400, Nicolas Pitre wrote:
> 
> > > git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl | wc
> > >      58     163    2169
> > > 
> > > That's the patch we're actually discussing too. It's about one CC per
> > > file modified.
> > 
> > What is a mailing list for, then?  Why are you subscribed?
> 
> I'm subscribes to review code .. Do you read every patch that cross the
> arm list?

No, But I do read every email subject, and most patch messages.  Only 
those subjects I know for sure I have no interest in I do delete right 
away.

And being a human I sometimes screw up and let something I should have 
paid attention fall through the cracks.  When that happens I simply fix 
the issue after the fact and send a patch, and then life goes on.

If you don't want to actually follow the mailing list traffic, you can 
at least filter it by flagging those messages that contain a patch which 
touches one of those files you do care about.


Nicolas
