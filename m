Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2D0BcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:32:06 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:39906 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632Ab2D0BcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:32:04 -0400
Date: Fri, 27 Apr 2012 11:31:52 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/crypto/amcc/crypto4xx_core.c: move up
 err_request_irq label
Message-ID: <20120427013152.GA32567@gondor.apana.org.au>
References: <1334436521-28622-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334436521-28622-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 10:48:41PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Move the err_request_irq error label up to reflect that tasklet_init and
> irq_of_parse_and_map have taken place.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
