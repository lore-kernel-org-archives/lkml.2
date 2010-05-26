Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0EZAhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:37:12 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:47126 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758448Ab0EZAhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:37:10 -0400
Date: Wed, 26 May 2010 10:37:02 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/8] crypto: Use ERR_CAST
Message-ID: <20100526003701.GA20073@gondor.apana.org.au>
References: <Pine.LNX.4.64.1005221159290.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005221159290.13021@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 11:59:48AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
> clear what is the purpose of the operation, which otherwise looks like a
> no-op.

Patch applied.  Thanks Julia.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
