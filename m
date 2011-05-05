Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1EEPZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:25:09 -0400
Received: from kroah.org ([198.145.64.141]:40488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1EEPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:25:08 -0400
Date: Thu, 5 May 2011 08:25:01 -0700
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: -longterm kernels (Was: Re: [stable] Patch Upstream: iwlwifi:
 fix skb usage after free)
Message-ID: <20110505152501.GA14146@kroah.com>
References: <201105030110.p431A5W0005426@hera.kernel.org>
 <20110504223605.GA5967@kroah.com>
 <20110505145854.GA4670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505145854.GA4670@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 04:58:55PM +0200, Stanislaw Gruszka wrote:
> (Removing Cc as probably not interested, adding LKML)
> 
> On Wed, May 04, 2011 at 03:36:05PM -0700, Greg KH wrote:
> > > Cc: stable@kernel.org # 2.6.32+
> > 
> > This doesn't apply to the .32 or .33-stable kernels.  If you wish to see
> > it there, can someone please provide a backport and send it to
> > stable@kernel.org ?
> Done.
> 
> BTW, Greg, perhaps -logterm releasing policy should be revised somehow.
> Currently we have .32, .33, .34, .35 -longterm, what is kind a much.

It's not "much" if you rely on that kernel version, right?

Nor if you aren't doing the work, no one forces anyone to backport any
patches to older kernels if they don't want to.  The above patch was
asked to be backported as the original submitter wanted it there, hence
my asking for them to do it if they really wanted it.

> If
> I could suggest something, would be nice to have longterm chosen
> versions predictable and constants i.e. one from every 3 kernel
> releases, like .35, .38, .41 ... . That would make distributions, that
> try to do release every half year very happy, because they will know
> what kernel to choose, which will be widely supported and tested.

The distros are the ones doing this -stable and -longterm work, so they
very well know exactly what is going on.  If they want to have a
specific kernel version marked as "-longterm", then they do the work to
do so.

What happens in the future, with future releases, is always unknown, as
hey, it's the future :)

So I really fail to understand what you are asking for here.

> Also
> developers will have a bit less work with backporting fixes, as having
> same bug in n and n-3 release is less probable, than having the same bug
> in n and n-1.

Again, no developer has to backport anything they don't want to, please
never feel any pressure from me or any other stable/longterm maintainer
to do so.  In this specific case, that was the request of the original
developer, hence my request back to them.

thanks,

greg k-h
