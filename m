Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KIJaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:30:16 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:47282 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976Ab2KIJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:30:13 -0500
Date: Fri, 9 Nov 2012 17:30:05 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.7
Message-ID: <20121109093005.GA25632@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au>
 <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823083242.GA23102@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a potential panic in cryptd which may occur with
crypto drivers such as aesni-intel.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

 crypto/cryptd.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
