Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1IAPGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:06:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39439 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab1IAPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110901145902.GA31834@gondor.apana.org.au>
References: <20110901133952.GB14522@orbit.nwl.cc>
	<20110901141445.GA31447@gondor.apana.org.au>
	<CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>
	<20110901145902.GA31834@gondor.apana.org.au>
Date: Thu, 1 Sep 2011 17:06:06 +0200
X-Google-Sender-Auth: JgYZNJFeNP1Im53hdjb1nd_cMc0
Message-ID: <CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Phil Sutter <phil@nwl.cc>, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 4:59 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:

>> latency, maybe(?) high throughput or so). Thus, I designed this
>> benchmark with a use-case in mind, i.e., a TLS or DTLS tunnel
>> executing in a system with such an accelerator. There might be other
>> benchmarks with other use cases in mind, but I haven't seen any.
> Putting TLS data-path in user-space is always going to be less
> than optimal, especially with hardware crypto offload, since you'll
> be crossing the user-space/kernel boundary multiple times.

Indeed but today that's what we have in some systems. User-space TLS
implementations (GnuTLS and OpenSSL) and kernel-space crypto
offloading. The purpose of the /dev/crypto and AF_ALG interfaces is to
connect those together. It would be interesting to have a partial
kernel-space TLS implementation but I don't know whether such a thing
could ever make it to kernel.

regards,
Nikos
