Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2D0BcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:32:22 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:43733 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632Ab2D0BcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:32:19 -0400
Date: Fri, 27 Apr 2012 11:32:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Deepak Saxena <dsaxena@plexity.net>, kernel-janitors@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/hw_random/omap-rng.c: use
 devm_request_and_ioremap
Message-ID: <20120427013208.GB32567@gondor.apana.org.au>
References: <1334855948-31146-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334855948-31146-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 07:19:08PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Using devm_request_and_ioremap is more concise.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
