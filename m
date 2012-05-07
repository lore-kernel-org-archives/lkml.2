Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2EGEUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 00:20:21 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:53642 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038Ab2EGEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 00:20:19 -0400
Date: Mon, 7 May 2012 14:20:17 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
Message-ID: <20120507042017.GC25039@gondor.apana.org.au>
References: <20120507123100.09a614d4f4eb1bfc14e64351@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507123100.09a614d4f4eb1bfc14e64351@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 12:31:00PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-ux500/devices-common.c between commit 3510ec672319 ("ARM:
> ux500: remove intermediary add_platform_device* functions") from Linus'
> tree and commit 3ba812f4d0be ("mach-ux500: crypto - core support for
> CRYP/HASH module") from the crypto tree.
> 
> I can't easily resolve this, sorry.  This crypto patch needs to be
> revised on top of v3.4-rc1.
> 
> I have use the crypto tree from next-20120504 for today.

OK I'll fix it up.  Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
