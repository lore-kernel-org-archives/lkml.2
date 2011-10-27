Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1J0HqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:46:01 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41325 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1J0Hp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:45:59 -0400
Date: Thu, 27 Oct 2011 09:45:44 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Valdis.Kletnieks@vt.edu
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Message-ID: <20111027074544.GA19905@gondor.apana.org.au>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net> <20111026062717.GA10230@gondor.apana.org.au> <7836.1319699116@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7836.1319699116@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 03:05:16AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 Oct 2011 08:27:17 +0200, Herbert Xu said:
> > On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
> > > When CONFIG_NET is not enabled:
> >
> > Thanks, I'll add this patch.
> 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > +	select NET
> 
> Are there any use cases where a config (probably embedded) would wantq
> CRYPTO_USER but not CRYPTO_NET?  Would seem a shame to pull in the entire

Since the CRYPTO_USER interface sits on top of netlink I don't
see how you could possibly avoid NET.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
