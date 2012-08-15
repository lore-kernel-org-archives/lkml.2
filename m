Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2HOO4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:56:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37103 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab2HOO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:56:14 -0400
Date: Wed, 15 Aug 2012 15:55:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Shan Kang <kangshan0910@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 20/82] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
Message-ID: <20120815145552.GI29448@mudshark.cambridge.arm.com>
References: <20120813201746.448504360@linuxfoundation.org>
 <20120813201748.202917513@linuxfoundation.org>
 <1345038982.824.216.camel@deadeye.wl.decadent.org.uk>
 <20120815140808.GD22871@kroah.com>
 <1345039901.824.221.camel@deadeye.wl.decadent.org.uk>
 <20120815144956.GB6320@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815144956.GB6320@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:49:56PM +0100, Greg Kroah-Hartman wrote:
> > Will Deacon wrote:
> > > The additional patch should also be CC'd to stable and is sitting in -tip
> > > somewhere I believe, so it shouldn't be long before it does hit mainline.
> > > 
> > > Without this patch there's a memory-ordering bug (which we seem to have hit
> > > once in > 5 years). With the patch there's a mutex lockup issue on SMP systems
> > > that I can provoke with enough hackbenching, so you may want to hold off for
> > > now.
> 
> Ah, ok, missed that.
> 
> How about I just drop this for now, and when someone (Will?) feels it is
> "good enough time to wait", they will resend it to
> stable@vger.kernel.org so that we can add it then?  Otherwise I'll just
> loose it somewhere.

Fine by me. It doesn't conflict with the other patch either, so it won't be
a problem if you get that one first.

Will
