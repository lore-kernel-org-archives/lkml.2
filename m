Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1JUIXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:23:08 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36907 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1JUIXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:23:07 -0400
Date: Fri, 21 Oct 2011 10:22:59 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.1
Message-ID: <20111021082259.GA13530@gondor.apana.org.au>
References: <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629235153.GA16559@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a NULL-pointer dereference that can be triggered
from user-space.

Please pull from

git://github.com/herbertx/crypto.git


Nick Bowler (1):
      crypto: ghash - Avoid null pointer dereference if no key is set

 crypto/ghash-generic.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
