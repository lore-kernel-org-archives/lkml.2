Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1BCAPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:15:34 -0500
Received: from relais.videotron.ca ([24.201.245.36]:52256 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1BCAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:15:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 02 Feb 2011 19:15:32 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <8yaipx259h7.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1102021902110.8212@xanadu.home>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
 <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
 <20110202200030.GA26104@flint.arm.linux.org.uk>
 <20110202203252.GD28479@kroah.com>
 <20110202204453.GB26104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
 <8yaipx259h7.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, David Brown wrote:

> On Wed, Feb 02 2011, Nicolas Pitre wrote:
> 
> > The actual problem here is that some people, notably the msm folks, are 
> > bypassing the maintainer hierarchy and going straight to Linus for their 
> > pull requests instead of asking RMK to pull.  We once debated this at 
> > some point and it was agreed that completely independent SOC specific 
> > code with no dependencies on the common ARM code _could_ go straight to 
> > Linus directly if they crave for it.
> 
> I also have no real problem sending pull requests to RMK instead of
> Linus, as long as it isn't a pain.  Linus gives clear directions as to
> how his tree works, and when he expects what kinds of pull requests.
> Weird web-based patch tracking systems are a pain.  Pull requests from
> git with a fairly easy way to know when they've been pulled are not.

RMK accepts pull requests.  He also stated pretty clearly when he wishes 
for those requests to happen, or rather when it is too late for those 
requests to come by so he has a chance to sort his tree out in time for 
the merge window.

> I also find that http://ftp.arm.linux.org.uk/ is frequently
> inaccessable, and usually slow.

The "slow" part should be fixed now that the Git server over there has 
been configured to serve Git requests using the Git smart protocol over 
HTTP.

Admitedly, if RMK had a public mirror on git.kernel.org that would help 
things (a lot of people do have rebasing Git repos there already).

> As it stands, so far, it's been a lot less work for me to send directly
> to Linus, and resolve the issues that come up when they do.

This is however more work for Linus who already expressed some concerns 
about too many people going to him directly while he'd prefer a more 
distributed flow.


Nicolas
