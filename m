Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0EXL1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:27:32 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:51149 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756617Ab0EXL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:27:30 -0400
Date: Mon, 24 May 2010 21:27:26 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC][PATCH] crypto: disable tests when they are not enabled
Message-ID: <20100524112726.GB29848@gondor.apana.org.au>
References: <1274693724-23831-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274693724-23831-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 12:35:24PM +0300, Alexander Shishkin wrote:
> Don't compile in and don't schedule cryptomanager's tests when
> CONFIG_CRYPTO_TESTS is not set. This saves quite some time during
> kernel initialization.

You're disabling the self-testing infrastructure.  This is not
the same thing as the tcrypt module.

Is this for fast booting?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
