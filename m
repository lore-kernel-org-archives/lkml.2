Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0ESM7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:59:52 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:51764 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758052Ab0ESM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:59:49 -0400
Date: Wed, 19 May 2010 22:59:03 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Woodhouse <dwmw2@infradead.org>, David Miller <davem@davemloft.net>,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100519125903.GA27496@gondor.apana.org.au>
References: <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <1274224834.6930.8361.camel@macbook.infradead.org> <20100519010524.GB18813@gondor.apana.org.au> <1274266725.6930.9823.camel@macbook.infradead.org> <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com> <1274267805.6930.9877.camel@macbook.infradead.org> <20100519114609.GA26610@gondor.apana.org.au> <AANLkTiky-saTpv6Vq2ipIWC39b5eox92qQGE0QcACEBR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiky-saTpv6Vq2ipIWC39b5eox92qQGE0QcACEBR@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 03:54:43PM +0300, Pekka Enberg wrote:
>
> OK, I'll pick up David's patches and just wait for sparc changes to
> hit Linus' tree first. Herbert, do I have your ACK for the crypto
> patches?

Of course:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
