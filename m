Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1JZG1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:27:40 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45434 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1JZG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:27:39 -0400
Date: Wed, 26 Oct 2011 08:27:17 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Message-ID: <20111026062717.GA10230@gondor.apana.org.au>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA75759.3050900@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
> On 10/25/11 02:36, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> When CONFIG_NET is not enabled:

Thanks, I'll add this patch.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a8442dc..259dea9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -103,6 +103,7 @@ config CRYPTO_MANAGER2
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
 	select CRYPTO_MANAGER
+	select NET
 	help
 	  Userapace configuration for cryptographic instantiations such as
 	  cbc(aes).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
