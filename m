Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2D3KCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:02:37 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:42909 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755847Ab2D3KCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:02:36 -0400
Date: Mon, 30 Apr 2012 20:02:23 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH] hwrng: Kconfig: modify default state for atmel-rng
 driver
Message-ID: <20120430100223.GA32204@gondor.apana.org.au>
References: <20120427173504.GK18260@opensource.wolfsonmicro.com>
 <1335779353-9515-1-git-send-email-nicolas.ferre@atmel.com>
 <20120430095511.GC3170@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430095511.GC3170@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 10:55:12AM +0100, Mark Brown wrote:
> On Mon, Apr 30, 2012 at 11:49:13AM +0200, Nicolas Ferre wrote:
> > In order to prevent building the Atmel hw_random driver for each and every
> > configuration, add a "default" Kconfig state in relation with
> > CONFIG_ARCH_AT91.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
