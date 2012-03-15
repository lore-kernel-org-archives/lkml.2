Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130Ab2COXyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:54:23 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:57354 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761665Ab2COXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:54:22 -0400
Date: Fri, 16 Mar 2012 10:54:06 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com, vinod.koul@intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH 6/6] hwrng: Kconfig: remove dependency for atmel-rng
	driver
Message-ID: <20120315235406.GB18496@gondor.apana.org.au>
References: <cover.1331826095.git.nicolas.ferre@atmel.com> <c3455cec019bedacc6ff58cf8cd2ae25cdeb212f.1331826095.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3455cec019bedacc6ff58cf8cd2ae25cdeb212f.1331826095.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:57:22PM +0100, Nicolas Ferre wrote:
> This will allow to select this driver for newer SoCs. Make sure to
> keep dependency on HAVE_CLK to avoid breaking other machines.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
