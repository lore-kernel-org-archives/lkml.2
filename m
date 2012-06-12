Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab2FLKFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:05:39 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:45407 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875Ab2FLKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:05:37 -0400
Date: Tue, 12 Jun 2012 18:05:26 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Message-ID: <20120612100526.GE14078@gondor.apana.org.au>
References: <20120528135424.GI17705@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528135424.GI17705@kronos.redsun>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 03:54:24PM +0200, Johannes Goetzfried wrote:
> This patch adds a x86_64/avx assembler implementation of the Twofish block
> cipher. The implementation processes eight blocks in parallel (two 4 block
> chunk AVX operations). The table-lookups are done in general-purpose registers.
> For small blocksizes the 3way-parallel functions from the twofish-x86_64-3way
> module are called. A good performance increase is provided for blocksizes
> greater or equal to 128B.
> 
> Patch has been tested with tcrypt and automated filesystem tests.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
