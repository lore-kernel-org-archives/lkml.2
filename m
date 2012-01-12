Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2ALXEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:04:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44217 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab2ALXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:04:13 -0500
X-Sasl-enc: +SITck5wgcZ/h31F4BxLsJX8LeY9wlpqYAKWuQncM07i 1326409452
Date: Thu, 12 Jan 2012 15:01:33 -0800
From: Greg KH <greg@kroah.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [00/40] 3.0.17-stable review
Message-ID: <20120112230133.GC3360@kroah.com>
References: <20120110214630.GA14384@kroah.com>
 <20120111222158.GA20915@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111222158.GA20915@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 05:21:58PM -0500, Nick Bowler wrote:
> Hi Greg,
> 
> On 2012-01-10 13:46 -0800, Greg KH wrote:
> > This is the start of the stable review cycle for the 3.0.17 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> These upstream commits (in 3.2):
> 
>   b7ea81a58adc ("ah: Read nexthdr value before overwriting it in ahash input callback.")
>   069294e813ed ("ah: Correctly pass error codes in ahash output callback.")
> 
> made it into the 3.1.y series but they appear to not have made it into
> 3.0.y, where they're also applicable.  Also, the following one fixes a
> real bug so it may be 3.0.y material, although I'm not sure if any
> in-tree drivers can trigger it (this one requires a real ahash driver
> for real hardware to trigger; unlike the previous two, cryptd won't do):
> 
>   4b90a603a1b2 ("ah: Don't return NET_XMIT_DROP on input")

I rely on the networking maintainer (i.e. David) to send me network
patches.  If he acks these, I'll be glad to queue them up for the next
3.0-stable release.

thanks,

greg k-h
