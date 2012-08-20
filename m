Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2HTIcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:32:06 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:49685 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755825Ab2HTIcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:32:01 -0400
Date: Mon, 20 Aug 2012 16:31:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, patches@linaro.org,
        Nicolas Royer <nicolas@eukrea.com>
Subject: Re: [PATCH] crypto: atmel - Remove possible typo error
Message-ID: <20120820083156.GD22951@gondor.apana.org.au>
References: <1344340934-1319-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344340934-1319-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:32:14PM +0530, Tushar Behera wrote:
> Commit bd3c7b5c2aba ("crypto: atmel - add Atmel AES driver") possibly
> has a typo error of adding an extra CONFIG_.
> 
> CC: Nicolas Royer <nicolas@eukrea.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
