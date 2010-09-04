Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0IDMW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:22:57 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54022 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0IDMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:22:56 -0400
Date: Sat, 4 Sep 2010 20:22:45 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.35
Message-ID: <20100904122245.GA10640@gondor.apana.org.au>
References: <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100904064501.09ab7450@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100904064501.09ab7450@katamari>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 06:45:01AM -0400, Chuck Ebbert wrote:
> On Fri, 3 Sep 2010 14:00:55 +0800
> Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> 
> > Please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> > 
> > or
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> > 
> > 
> > Herbert Xu (2):
> >       crypto: testmgr - Fix test disabling option
> >       crypto: testmgr - Default to no tests
> > 
> > Szilveszter Ördög (1):
> >       crypto: hash - Fix handling of small unaligned buffers
> > 
> 
> What happened to my minor fix?
> 
>  [ http://marc.info/?l=linux-crypto-vger&m=128311860504202&w=2 ]
> 
> I never got a reply about it.

Hmm I did send you a reply.

Anyway it's in cryptodev-2.6.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
