Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2I0FoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:44:14 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:58291 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755601Ab2I0FoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:12 -0400
Date: Wed, 26 Sep 2012 22:43:57 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: davem@davemloft.net, linus.walleij@linaro.org,
        andreas.westin@stericsson.com, rjw@sisk.pl,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/crypto/ux500/cryp/cryp_core.c: fix error
 return code
Message-ID: <20120927054356.GB22311@gondor.apana.org.au>
References: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 07:28:25PM +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

All four patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
