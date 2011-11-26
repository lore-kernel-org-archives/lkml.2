Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KZCeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:34:24 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:45682 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1KZCeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:34:23 -0500
Date: Sat, 26 Nov 2011 10:34:14 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.2
Message-ID: <20111126023413.GA31106@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20111021082259.GA13530@gondor.apana.org.au> <20111110230014.GA4470@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110230014.GA4470@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus:

This push fixes a problem with mv_cesa the driver where it makes
incorrect hashes on input chunks greater than 1920 bytes.

Please pull from

git://github.com/herbertx/crypto.git


The top commit object is

commit 274252862f386b7868f35bf5ceaa5391a8ccfdf3
Author: Phil Sutter <phil.sutter@viprinet.com>
Date:   Wed Nov 16 18:28:01 2011 +0100

    crypto: mv_cesa - fix hashing of chunks > 1920 bytes


Phil Sutter (1):
      crypto: mv_cesa - fix hashing of chunks > 1920 bytes

 drivers/crypto/mv_cesa.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)
 
Thanks,
- -- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBTtBP9McnHQpJsYunAQJpTg//XFdRLLF46ZZQID12VqrfBJB8VrzGWY0q
QQQH+oe5lq9ppjkFz5Fk2fsNSj5a3kDtPQK9SBVl0TThC0BVuA3lNXEmcfnQoOjZ
vj1KUl9zSiwVcKm/lkbzlDHdU6wE1MxwP8z3XEdMMs7Pj3YWf12XUZQSWkeeFiy0
Tz5Oz9hbIpYLW+U458xjhoODJAk7JSItS+N2ud7JcqwV7nTsGqP95mDsbfiXi7Fn
1FiXdFYogAyyqLPDi6EbENCEbIvfV1JEbg/S7LOe7akxZwlJg92cevGHS/oDbxuU
N7/9nxgANbZBG3ApUw6UAJWSBuJBZ4C96ABc/LXY8ZzgwYNaiNloNMr1F/j+MZQ0
AtP58bK6IcSw7QBi8qzKV7P0q/pAxOYnDeaS4Sla8Pb4MvEAblSJF45/YHBublrE
Y5tMif4ib8Gy/yXF6bu0ohfP0LfKtXq5pZK6C0blcYdMyxKxcaQWx+6fATOWxdCL
OcrY6q2/dYG+zXSWJs13/YfWFcn3sRdjnVqFo2ItUbvD3ZL9WSCKuhd9PUZPcxqW
VEXKDaKA1G9aAn+KNkciZ48SiYCOMm4Xl6l11bsV2nx13i401KoM5hLcFv5CfZ89
Xwu+j2N4mhlLxPG08H4zG19hLgOdpY0Ql5VsZPf3z4Bf0G+gnZC6StDgvfJHEX3Z
sKy1PVqrB7U=
=iYTU
-----END PGP SIGNATURE-----
