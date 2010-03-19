Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0CSAeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:34:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54589 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867Ab0CSAeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:34:01 -0400
Date: Fri, 19 Mar 2010 08:33:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: michael-dev@fami-braun.de
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100319003351.GC20227@gondor.apana.org.au>
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com> <4BA29A19.2050307@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA29A19.2050307@fami-braun.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
> 
> Pekka Enberg schrieb:
> > Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
> > CONFIG_SLUB_DEBUG_ON?
> 
> no, these options have not been / are not enabled.

Can you please try it with those options enabled? That will tell
us if there is some latent bug in the crypto layer that only shows
up right away under SLOB.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
