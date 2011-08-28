Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1H1PIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 11:08:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41060 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab1H1PIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 11:08:04 -0400
X-Sasl-enc: QKM4Y9lZFrphTlB42yg5y3rZIWHm7YRs0yxcCKO1AJUk 1314544083
Date: Sun, 28 Aug 2011 08:07:57 -0700
From: Greg KH <greg@kroah.com>
To: Stratos Psomadakis <psomas@gentoo.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/19] 2.6.32.46-longterm review
Message-ID: <20110828150757.GA16301@kroah.com>
References: <20110826220137.GA14059@kroah.com>
 <4E5A35CB.7060005@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5A35CB.7060005@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 03:34:19PM +0300, Stratos Psomadakis wrote:
> On 08/27/2011 01:01 AM, Greg KH wrote:
> > This is the start of the longterm review cycle for the 2.6.32.46 release.
> > There are 19 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> >
> > Responses should be made by Monday, August 29, 2011, 12:00:00 UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.46-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> Hi,
> 
> upstream commit d5aa407f59f5b83d2c50ec88f5bf56d40f1f8978 ("tunnels: fix
> netns vs proto registration ordering") , which was included in
> 2.6.32.44-longterm, was not backported correctly, and results in a NULL
> pointer dereference in ip6_tunnel.c for longterm kernels 2.6.32.44 and
> 2.6.32.45.
> 
> The bug has been reported at the Gentoo [1] and Debian [2] bugzillas,
> and fixed in the latest grsec-patches [3], but I haven't found a report
> for this at the lkml (or at the kernel's bugzilla).
> 
> The fix is trivial, and I think it can be included in 2.6.32.46, if
> possible.
> If you want, I can submit it with a new email to stable@kernel.org.

Yes, please do so I can properly add it.

thanks,

greg k-h
