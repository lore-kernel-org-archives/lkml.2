Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0GaPOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 11:14:38 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43619 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab0GaPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 11:14:37 -0400
Date: Sat, 31 Jul 2010 23:14:22 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: reorder struct entropy_store to remove padding
	on 64bits
Message-ID: <20100731151422.GA19166@gondor.apana.org.au>
References: <1280309521.2029.5.camel@castor.rsk> <1280332948.11415.705.camel@calx> <20100731115819.GA18319@gondor.apana.org.au> <1280583392.25898.47.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280583392.25898.47.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 08:36:32AM -0500, Matt Mackall wrote:
>
> Oops, I forgot to cc: you on this and Andrew queued it. Andrew, I've
> been queueing the RNG bits through Herbert's crypto tree lately.

I think Andrew's scripts are clever enough to remove patches
once they show up in another tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
