Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1HPMcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 08:32:32 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34718 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HPMca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 08:32:30 -0400
Date: Tue, 16 Aug 2011 20:32:27 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110816123227.GB9413@gondor.apana.org.au>
References: <20110811164040.GB2167@zod.bos.redhat.com> <20110815071528.GA29656@gondor.apana.org.au> <20110815115038.GA2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815115038.GA2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 07:50:39AM -0400, Josh Boyer wrote:
>
> Well, yes, it does in this code:
> 
> 	if (!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> 	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> 					  alg->cra_ablkcipher.ivsize)) {
> 
> 		printk(KERN_ERR "%s: %d\n", __func__, __LINE__);
> 		return alg;
> 	}
> 
> But the lookup seems to fail after it returns (see traces below).

OK something's clearly screwed up.  I'll try to reproduce this
here.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
