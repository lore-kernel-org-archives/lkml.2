Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab1K3ISj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:18:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:48988 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab1K3ISg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:18:36 -0500
Date: Wed, 30 Nov 2011 16:18:28 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
Message-ID: <20111130081828.GB692@gondor.apana.org.au>
References: <4ECD527E.8000506@xenotime.net> <20111124063741.17986.23462.stgit@localhost6.localdomain6> <4ECE8E71.1080606@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECE8E71.1080606@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:35:29AM -0800, Randy Dunlap wrote:
> On 11/23/2011 10:37 PM, Jussi Kivilinna wrote:
> > Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
> > CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.
> > 
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Patch applied.  Thanks
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
