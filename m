Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1HRRoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1HRRoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:44:32 -0400
Date: Thu, 18 Aug 2011 13:44:25 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110818174425.GN2227@zod.bos.redhat.com>
References: <20110811164040.GB2167@zod.bos.redhat.com>
 <20110815071528.GA29656@gondor.apana.org.au>
 <20110815115038.GA2227@zod.bos.redhat.com>
 <20110816123227.GB9413@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816123227.GB9413@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:32:27PM +0800, Herbert Xu wrote:
> On Mon, Aug 15, 2011 at 07:50:39AM -0400, Josh Boyer wrote:
> >
> > Well, yes, it does in this code:
> > 
> > 	if (!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> > 	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> > 					  alg->cra_ablkcipher.ivsize)) {
> > 
> > 		printk(KERN_ERR "%s: %d\n", __func__, __LINE__);
> > 		return alg;
> > 	}
> > 
> > But the lookup seems to fail after it returns (see traces below).
> 
> OK something's clearly screwed up.  I'll try to reproduce this
> here.

Any luck on this?  If there's anything further I can try or if you need
some data from me, just let me know.

josh
