Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2E1NwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:52:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2E1NwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:52:07 -0400
Date: Mon, 28 May 2012 15:52:03 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Message-ID: <20120528135203.GH17705@kronos.redsun>
References: <20120527144919.GE17705@kronos.redsun>
 <20120528092505.211453i11cwxhp4w@naisho.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528092505.211453i11cwxhp4w@naisho.dyndns.info>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:9LdlBENPcefWDUBq3BMtTpf5ac8el4dF54GZ6bc6VIe
 LcEAwnYLmZvQssDzAoeO3Qx7U+Ll8qd3V41VwYx5C4he/m62T5
 Q435GfIvr1rYzNPdQxPGDFM5AqCx3XDfV7BUv6cm998JxVlm28
 q2Qi/cfO8QO6yXGXMZ0j/WEdlSLUODCYg2thdMQc9c5MhNRT+U
 jxMvHhhQdayfviAoW5Uh46N65cR84JCUfdUvIZkxD+FRHgKISg
 t/S+4xVg92FSss0LGr08wIw2Dd4/z/gRnnxQJ7ykAtZdjQoQbI
 ewst21zhnVzfvnrFeyr4V/BQFlq9Mp9q9hcIQK1e3DP9c2nqLn
 6W8u/8dkevJ9AerWWjTA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> It would be benefical to expand the twofish vectors in
> crypto/testmgr.h from 3 blocks
> to 8 blocks so that 8-way algorithm(s) can be checked runtime. And
> while at expanding
> test-vectors, why not just expand to 16 blocks... AVX2 is just one year away:
> https://github.com/jkivilin/crypto-avx2/commit/1a72d7a6a1553aee70ad4b6a1980ca372181f40d

that's a good idea. Thank you for the link to your commit. I will send this as
an extra patch.

> I think you mean serpent_sse2_glue.c :)

Yeah, that's right, I replaced a bit too much *g* I will resend the patch.

- Johannes
