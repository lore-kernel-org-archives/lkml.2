Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2HTIdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:33:10 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:33111 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798Ab2HTIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:33:08 -0400
Date: Mon, 20 Aug 2012 16:32:47 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
Message-ID: <20120820083247.GF22951@gondor.apana.org.au>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
 <201208081622.29777.arnd@arndb.de>
 <s5hwr19fi6h.wl%tiwai@suse.de>
 <201208081726.21878.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208081726.21878.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 05:26:21PM +0000, Arnd Bergmann wrote:
> 
> Ok. this leaves the omap-rng driver, and my patch comes down to the below.
> Thanks!

Patch applied.  Thanks Arnd.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
