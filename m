Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2EGJEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:04:39 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:60163 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755564Ab2EGJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:04:37 -0400
Date: Mon, 7 May 2012 19:04:27 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Westin <andreas.westin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
Message-ID: <20120507090427.GA26654@gondor.apana.org.au>
References: <20120507121137.bdfc96ed31649040506d9c75@canb.auug.org.au>
 <201205070809.21709.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205070809.21709.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 08:09:21AM +0000, Arnd Bergmann wrote:
> On Monday 07 May 2012, Stephen Rothwell wrote:
> > + static void __init u8500_cryp1_hash1_init(void)
> > + {
> > +       db8500_add_cryp1(&u8500_cryp1_platform_data);
> > +       db8500_add_hash1(&u8500_hash1_platform_data);
> > + }
> 
> This is actually not correct any more because of the
> other changes: each device addition should also pass the parent
> pointer so the device is created in the right position.
> 
> Stephen, your fix is ok for linux-next and I expect everything
> to still work, but we should not merge it into v3.5 this way.
> 
> Thanks for the fixup.

OK, I'll drop the last patch

	mach-ux500: crypto - core support for CRYP/HASH module

from my tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
