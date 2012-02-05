Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2BEEOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:14:33 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:54343 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2BEEOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:14:32 -0500
Date: Sun, 5 Feb 2012 15:14:24 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tristan Pourcelot <tristan.pourcelot@gmail.com>
Cc: davem@davemloft.net, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correcting some style issues
Message-ID: <20120205041424.GB8219@gondor.apana.org.au>
References: <1328190031.6508.1.camel@blackout-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328190031.6508.1.camel@blackout-netbook>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:40:31PM +0100, Tristan Pourcelot wrote:
> >From d50e5530201aa02a5232ca9f2458a7fdd18de374 Mon Sep 17 00:00:00 2001
> From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
> Date: Thu, 2 Feb 2012 14:01:03 +0100
> Subject: [PATCH] Correcting some style errors in
>  drivers/crypto/geode-aes.c 
> Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>

Sorry, your patch doesn't apply against cryptodev:

$ git apply ~/p
2 out of 3 hunks FAILED -- saving rejects to file drivers/crypto/geode-aes.c.rej
$

Please check and resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
