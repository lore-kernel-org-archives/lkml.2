Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0GaNgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 09:36:37 -0400
Received: from waste.org ([173.11.57.241]:45677 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0GaNgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 09:36:36 -0400
Subject: Re: [PATCH] random: reorder struct entropy_store to remove padding
 on 64bits
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100731115819.GA18319@gondor.apana.org.au>
References: <1280309521.2029.5.camel@castor.rsk>
	 <1280332948.11415.705.camel@calx>
	 <20100731115819.GA18319@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 08:36:32 -0500
Message-ID: <1280583392.25898.47.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 19:58 +0800, Herbert Xu wrote:
> On Wed, Jul 28, 2010 at 11:02:28AM -0500, Matt Mackall wrote:
> > On Wed, 2010-07-28 at 10:32 +0100, Richard Kennedy wrote:
> > > Re-order structure entropy_store to remove 8 bytes of padding on
> > > 64 bit builds, so shrinking this structure from 72 to 64 bytes
> > > and allowing it to fit into one cache line.
> > 
> > I have a vague memory that we reordered things so that the r/w bits
> > would be on a separate cache line than the r/o bits. But as we never
> > added the alignment primitives to actually enforce that, I guess it
> > doesn't matter much. 
> > 
> > > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> Patch applied.  Thanks!

Oops, I forgot to cc: you on this and Andrew queued it. Andrew, I've
been queueing the RNG bits through Herbert's crypto tree lately.

-- 
Mathematics is the supreme nostalgia of our time.


