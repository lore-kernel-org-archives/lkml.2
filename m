Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1KAWTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:19:25 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46317 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1KAWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:19:22 -0400
Date: Wed, 2 Nov 2011 09:16:01 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: Fix rwsem leak in crypto_user
Message-ID: <20111101221600.GB4519@gondor.apana.org.au>
References: <20111101160837.7da3ef6d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101160837.7da3ef6d@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:08:37PM -0600, Jonathan Corbet wrote:
> The list_empty case in crypto_alg_match() will return without calling
> up_read() on crypto_alg_sem.  We could do the "goto out" routine, but the
> function will clearly do the right thing with that test simply removed.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Patch applied.  Thanks a lot Jon!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
