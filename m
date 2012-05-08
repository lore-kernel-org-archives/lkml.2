Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2EHKBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:01:16 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:38142 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753414Ab2EHKBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:01:14 -0400
Date: Tue, 8 May 2012 20:00:58 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the crypto
 tree
Message-ID: <20120508100058.GB2113@gondor.apana.org.au>
References: <20120508172153.b05c9d198b1b81c652a2bde6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508172153.b05c9d198b1b81c652a2bde6@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 05:21:53PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/char/hw_random/Kconfig between commit 028fdd87b79a ("hwrng:
> Kconfig - modify default state for atmel-rng driver") from the crypto
> tree and commit 1234f4bada54 ("hwrng: Kconfig: remove dependency for
> atmel-rng driver") from the arm-soc tree.
> 
> Juts context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good.  Thanks Stephen!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
