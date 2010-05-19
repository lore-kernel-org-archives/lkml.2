Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0ESLqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:46:44 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:46782 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754021Ab0ESLqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:46:42 -0400
Date: Wed, 19 May 2010 21:46:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Miller <davem@davemloft.net>,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100519114609.GA26610@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <1274224834.6930.8361.camel@macbook.infradead.org> <20100519010524.GB18813@gondor.apana.org.au> <1274266725.6930.9823.camel@macbook.infradead.org> <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com> <1274267805.6930.9877.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274267805.6930.9877.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:16:45PM +0100, David Woodhouse wrote:
>
> I don't mind. Feel free to apply them to slab.git, but be aware that
> Herbert wanted to see a patch fixing sparc32 ARCH_SLAB_MINALIGN before
> the crypto one is applied.
> 
> Although arguably SLOB was broken on sparc32 even before the crypto
> patch -- so perhaps that fix shouldn't _have_ to go in first?

Well prior to this crypto on sparc32 did work with SLAB/SLUB.  If
you change it without including the sparc pach, then sparc32 would
be broken regardless of which allocator you used.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
