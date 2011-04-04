Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1DDXUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:20:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1DDXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:20:09 -0400
Date: Tue, 5 Apr 2011 00:20:01 +0100
From: James Hogan <james@albanarts.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Hogan <james.hogan@imgtec.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
Message-ID: <20110404232001.GA14102@gandalf.le.imgtec.org>
References: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
 <4D9A18F3.3090506@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9A18F3.3090506@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Mon, Apr 04, 2011 at 03:16:03PM -0400, Chris Metcalf wrote:
> On 4/4/2011 11:21 AM, James Hogan wrote:
> > From: James Hogan <james.hogan@imgtec.com>
> >
> > Note: I'm not in a position to compile test this patch, but I don't
> > foresee any problems.
> >
> > Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
> > (d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
> > struct dev pointer, but these appear to be missing from the tile and
> > mn10300 implementations, so add them.
> >
> > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > ---
> >  arch/mn10300/include/asm/dma-mapping.h |    2 +-
> >  arch/tile/include/asm/dma-mapping.h    |    3 ++-
> >  arch/tile/kernel/pci-dma.c             |    2 +-
> 
> This change looks fine for tile (not compile-tested but pretty obvious), so
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks

> 
> assuming you're planning to push this up yourself.

I'm not sure. I'm not that familiar with the process (my other patches
tend to have just been picked up by other people).

Cheers
James
