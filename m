Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2FLARV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:17:21 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:42285 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751664Ab2FLARU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:17:20 -0400
Date: Tue, 12 Jun 2012 09:15:45 +0900
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org, GPontis@z9.com, stable@vger.kernel.org
Subject: Re: [PATCH] hw_random: atmel-rng: fix data valid check
Message-ID: <20120612001545.GA10484@gondor.apana.org.au>
References: <1337776317-25679-1-git-send-email-jacmet@sunsite.dk>
 <4FBCDF85.5030707@atmel.com>
 <4FD619B9.9070802@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD619B9.9070802@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 06:15:53PM +0200, Nicolas Ferre wrote:
> 
> It seems that this patch did not make it in your tree before the "other
> one" from Peter: in linus' tree: 121daad (hwrng: atmel-rng - fix race
> condition leading to repeated bits).
> 
> So, do you want me to rebase this patch because it will not apply anymore?

Oops, I'll fix this up.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
