Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1IAPIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:08:49 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42486 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1IAPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:08:47 -0400
Date: Thu, 1 Sep 2011 23:08:38 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: Phil Sutter <phil@nwl.cc>, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901150838.GA31988@gondor.apana.org.au>
References: <20110901133952.GB14522@orbit.nwl.cc> <20110901141445.GA31447@gondor.apana.org.au> <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com> <20110901145902.GA31834@gondor.apana.org.au> <CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 05:06:06PM +0200, Nikos Mavrogiannopoulos wrote:
>
> Indeed but today that's what we have in some systems. User-space TLS
> implementations (GnuTLS and OpenSSL) and kernel-space crypto
> offloading. The purpose of the /dev/crypto and AF_ALG interfaces is to
> connect those together. It would be interesting to have a partial
> kernel-space TLS implementation but I don't know whether such a thing
> could ever make it to kernel.

Well we've talked about a kernel implementation of the data path
previously and I don't think there is any opposition to the idea.

The only thing missing is an implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
