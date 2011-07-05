Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1GERi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:38:27 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55829 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab1GERi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:38:26 -0400
X-Sasl-enc: /+EMU2xTuilC/SbWp/pCnBo8pFUz0DCQ3be+AUKVpNFi 1309887505
Date: Tue, 5 Jul 2011 10:38:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Clark <sclark46@earthlink.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel -2.6.35.13 longterm
Message-ID: <20110705173804.GA11421@kroah.com>
References: <4E13212D.3020005@earthlink.net>
 <20110705150557.GA2348@kroah.com>
 <4E134ACB.9020002@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E134ACB.9020002@earthlink.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 01:32:59PM -0400, Stephen Clark wrote:
> On 07/05/2011 11:05 AM, Greg KH wrote:
> >On Tue, Jul 05, 2011 at 10:35:25AM -0400, Stephen Clark wrote:
> >
> >>Hello,
> >>
> >>Is it possible to get the following patches included in the longterm kernel
> >>2.6.35.13?
> >>
> >Possibly, but you need to email the correct person and email address,
> >none of which you did :)
> >
> >Try stable@kernel.org, and the .35-longterm maintainer (hint, it's not
> >me.)
> >
> >
> Ok - hmmm maintainers in 2.6.35.13 still lists you - but I'll look
> at a later kernel maintainers file.

It's not really obvious who is in charge, the -longterm maintainer
really should put their name there.  I think for .35 it's Andi Kleen.

> >>They let linux behave according to:
> >>
> >>"Basic Requirements for IPv6 Customer Edge Routers
> >>    draft-ietf-v6ops-ipv6-cpe-router-09"
> >>
> >That looks like a new feature, not a regression or bugfix, right?
> >
> >Did you read Documentation/stable_kernel_rules.txt?
> >
> >
> Not til just now. Yes it is a new feature, but with IPV6 it is seems
> that it would be of use.
> I know that my company needs it as we are moving off of FreeBSD to Linux for our
> fw/vpn/router appliance. The alternative is to just keep applying the patch myself.

As described above, new features are not for stable or longterm kernels,
sorry.  I recommend just applying it yourself if you really are stuck
with the .35 kernel.

> >>From: Thomas Graf
> >>Subject: [PATCH] ipv6: add special mode accept_ra=2 to accept RA
> >>while configured as router
> >>Date: Friday, September 3, 2010 - 5:59 am
> >>
> >>
> >You forgot to mention what the git commit id this is upstream in Linus's
> >branch, and to copy the people involved in the original patch (author,
> >subsystem maintainer, etc.) to see if they agree it should go in.
> >
> >
> How in the world do you get the commit info?

>From the original patch and Linus's git tree?  Also, look at
scripts/get_maintainer.pl it will show you who to send stuff to.

Hope this helps,

greg k-h
