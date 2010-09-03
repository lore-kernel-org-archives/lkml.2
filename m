Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0ICLHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:07:30 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39538 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0ICLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:07:29 -0400
Date: Fri, 3 Sep 2010 19:07:22 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.36
Message-ID: <20100903110722.GA31826@gondor.apana.org.au>
References: <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100903060055.GA28915@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 02:00:55PM +0800, Herbert Xu wrote:
> Hi Linus:
> 
> This push fixes a bug in the new ahash walking code, as well as
> the self-test disabling option.  The self-test disabling options
> is now enabled by default as requested.

I missed a changeset in the push request.  This also includes a
revert of a bogus cast removal patch.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (3):
      crypto: testmgr - Fix test disabling option
      crypto: testmgr - Default to no tests
      Revert "hwrng: n2-drv - remove casts from void*"

Szilveszter Ördög (1):
      crypto: hash - Fix handling of small unaligned buffers

 crypto/Kconfig                  |    8 ++++----
 crypto/ahash.c                  |    7 +++++--
 crypto/algboss.c                |    8 ++++----
 crypto/testmgr.c                |    4 ++--
 drivers/char/hw_random/n2-drv.c |    2 +-
 5 files changed, 16 insertions(+), 13 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
