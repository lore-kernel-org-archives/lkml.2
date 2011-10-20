Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1JTMTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:19:15 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36061 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1JTMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:19:13 -0400
Date: Thu, 20 Oct 2011 14:19:08 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: ghash: Avoid null pointer dereference if no
	key is set.
Message-ID: <20111020121907.GB4001@gondor.apana.org.au>
References: <20111014171358.GA15626@elliptictech.com> <1318614795-16658-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318614795-16658-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 01:53:15PM -0400, Nick Bowler wrote:
> The ghash_update function passes a pointer to gf128mul_4k_lle which will
> be NULL if ghash_setkey is not called or if the most recent call to
> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
> up by returning an error code in the null case.

Patch applied.  Will push to stable as well.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
