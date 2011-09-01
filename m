Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab1IAOPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:15:06 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41775 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab1IAOPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:15:01 -0400
Date: Thu, 1 Sep 2011 22:14:45 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Phil Sutter <phil@nwl.cc>
Cc: nmav@gnutls.org, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901141445.GA31447@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901133952.GB14522@orbit.nwl.cc>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> 
> chunksize       af_alg          cryptodev       (100 * cryptodev / af_alg)
> --------------------------------------------------------------------------
> 512              4.169 MB/s      7.113 MB/s     171 %
> 1024             7.904 MB/s     12.957 MB/s     164 %
> 2048            13.163 MB/s     19.683 MB/s     150 %
> 4096            20.218 MB/s     26.960 MB/s     133 %
> 8192            27.539 MB/s     34.373 MB/s     125 %
> 16384           33.730 MB/s     39.997 MB/s     119 %
> 32768           37.399 MB/s     42.727 MB/s     114 %
> 65536           40.004 MB/s     44.660 MB/s     112 %

Are you maxing out your submission CPU? If not then you're testing
the latency of the interface, as opposed to the throughput.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
