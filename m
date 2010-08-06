Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935505Ab0HFJOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:14:52 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52541 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab0HFJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:14:47 -0400
Date: Fri, 6 Aug 2010 17:14:39 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: typo in crypto kconfig ?
Message-ID: <20100806091439.GA25891@gondor.apana.org.au>
References: <201008060942.16082.toralf.foerster@gmx.de> <20100806085756.GA13458@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100806085756.GA13458@fancy-poultry.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 10:57:56AM +0200, Heinz Diehl wrote:
> On 06.08.2010, Toralf Förster wrote: 
> 
> > While configuring the kernel v2.6.35-3797-gfc1caf6 I read this :
> > 
> > ...
> > Cryptographic API (CRYPTO) [Y/m/?] y
> >   *
> >   * Crypto core or helper
> >   *
> >   Cryptographic algorithm manager (CRYPTO_MANAGER) [M/y/?] m
> >   Run algolithms' self-tests (CRYPTO_MANAGER_TESTS) [Y/n/?] (NEW) 
> > 
> > and wonder now whether it should be spelled "algorithm" instead ?
> 
> Yes, that's simply a typo, it should be "algorithm" of course.

This is already gone in current crypt-2.6 tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
