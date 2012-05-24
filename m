Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2EXAVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:21:38 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:40404 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255Ab2EXAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:21:36 -0400
Date: Thu, 24 May 2012 10:21:26 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Westin <andreas.westin@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Crypto Update for 3.5
Message-ID: <20120524002126.GA28104@gondor.apana.org.au>
References: <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20120320032736.GA21367@gondor.apana.org.au>
 <20120523013528.GA20781@gondor.apana.org.au>
 <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:06:35PM -0700, Linus Torvalds wrote:
> On Tue, May 22, 2012 at 6:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Here is the crypto update for 3.5:
> 
> I pulled this, but quite frankly, some of it looks like utter garbage.
> 
> There's a declaration for dbx500_add_platform_device_noirq() that does
> not exist and is not used anywhere. Why? It was added in commit
> 585d188f8072, and I see no rhyme or reason to it.

I can't see why that was added there either.

Adding Arnd/Linus Walleij to see if they can tell us whether
it should go or stay.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
