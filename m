Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2GKDZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:25:18 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:53722 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753745Ab2GKDZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:25:16 -0400
Date: Wed, 11 Jul 2012 11:25:05 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] Exynos : Add support for Exynos random number
 generator
Message-ID: <20120711032504.GD5263@gondor.apana.org.au>
References: <1340930606-2604-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340930606-2604-1-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 09:43:26AM +0900, Jonghwa Lee wrote:
> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
> 5 random number outputs. Module is excuted under runtime power management control,
> so it activates only while it's in use. Otherwise it will be suspended generally.
> It was tested on PQ board by rngtest program.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
