Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1IAO47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:56:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54831 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab1IAO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110901141445.GA31447@gondor.apana.org.au>
References: <20110901133952.GB14522@orbit.nwl.cc>
	<20110901141445.GA31447@gondor.apana.org.au>
Date: Thu, 1 Sep 2011 16:56:56 +0200
X-Google-Sender-Auth: xyhtwFQSajTST5lLs9G_9AewLSs
Message-ID: <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Phil Sutter <phil@nwl.cc>, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 4:14 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:

> Are you maxing out your submission CPU? If not then you're testing
> the latency of the interface, as opposed to the throughput.

I think it is obvious that a benchmark of throughput measures
throughput. If however, you think that AF_ALG is in disadvantage in
this benchmark, because it is a high latency interface, you're free to
propose and perform another one. I haven't seen anywhere how is this
interface was supposed to be used, nor about its qualities (high
latency, maybe(?) high throughput or so). Thus, I designed this
benchmark with a use-case in mind, i.e., a TLS or DTLS tunnel
executing in a system with such an accelerator. There might be other
benchmarks with other use cases in mind, but I haven't seen any.

regards,
Nikos
