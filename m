Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2AMFjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:39:17 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:37292 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2AMFjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:39:16 -0500
Date: Fri, 13 Jan 2012 16:39:07 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/crypto/ixp4xx_crypto.c: convert GFP_KERNEL
	to GFP_ATOMIC
Message-ID: <20120113053907.GF13918@gondor.apana.org.au>
References: <1326102050-30265-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326102050-30265-3-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:40:49AM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia.lawall@lip6.fr>
> 
> The function is called with locks held and thus should not use GFP_KERNEL.
> 
> The semantic patch that makes this report is available
> in scripts/coccinelle/locks/call_kern.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
