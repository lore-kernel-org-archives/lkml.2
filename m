Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2JCHLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:11:55 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:56834 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754461Ab2JCHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:11:52 -0400
Date: Wed, 3 Oct 2012 15:11:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
Message-ID: <20121003071119.GA2571@gondor.apana.org.au>
References: <20121003054542.GA2416@havoc.gtf.org>
 <20121003.020619.772556428995851933.davem@davemloft.net>
 <506BE0E7.1070701@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506BE0E7.1070701@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:53:27AM -0400, Jeff Garzik wrote:
>
> Maybe my patch is the best we can do in the current kernel, if
> dynamic digest size is not currently possible. Register "sha3_224",
> "sha3_256", ... as you describe, and wait for actual users to appear
> with unsupported digest sizes.

Let's see what people use before we do anything more fancy.

If the variants really start proliferating, we can add a template
called "trunc" and then have things like "trunc(sha3,224)", etc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
