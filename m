Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2IGDeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:34:04 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:59524 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759305Ab2IGDeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:34:02 -0400
Date: Thu, 6 Sep 2012 20:33:58 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David McCullough <david_mccullough@mcafee.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the crypto tree with the
 sparc-next tree
Message-ID: <20120907033358.GB26360@gondor.apana.org.au>
References: <20120907125104.f9adc5ba55907e802cc8329b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907125104.f9adc5ba55907e802cc8329b@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 12:51:04PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got conflicts in
> crypto/Kconfig between commits 4ff28d4ca93b ("sparc64: Add SHA1 driver
> making use of the 'sha1' instruction") and 9bf4852d3d19 ("sparc64: Add
> AES driver making use of the new aes opcodes") from the sparc-next tree
> and commit f0be44f4fb1f ("arm/crypto: Add optimized AES and SHA1
> routines") from the crypto tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good.  Thanks Stephen!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
