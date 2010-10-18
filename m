Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab0JRU5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:57:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:57768 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0JRU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:57:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Oct 2010 16:57:32 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287433179.5588.9.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010181654300.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
 <20101018110207.131b56ee.sfr@canb.auug.org.au>
 <20101018081520.GA10551@flint.arm.linux.org.uk>
 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
 <20101018182044.GA558@flint.arm.linux.org.uk>
 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
 <1287433179.5588.9.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Daniel Walker wrote:

> On Mon, 2010-10-18 at 15:29 -0400, Nicolas Pitre wrote:
> 
> > RMK has his own merge window which closes about at the same time as 
> > Linus' one opens.  We thought this was happening last week and therefore 
> > this change was supposed to be the last one.
> 
> I guess what I'm missing here is when does this window open? Is it a two
> week deal, or does it last the whole -rc cycle?

Linus' merge window is indeed the two-week thing.  No one can predict 
with certainty when it'll happen, as demonstrated by our merging of the 
debug macro in RMK's tree last week based on the presumption that we 
would be in the two-week merge now.


Nicolas
