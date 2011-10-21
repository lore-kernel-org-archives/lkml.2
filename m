Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1JULfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:35:14 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:40039 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1JULfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:35:12 -0400
Date: Fri, 21 Oct 2011 13:35:01 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.1
Message-ID: <20111021113501.GA14657@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20111021082259.GA13530@gondor.apana.org.au> <alpine.DEB.2.00.1110210240290.12963@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110210240290.12963@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:41:54AM -0700, David Rientjes wrote:
> On Fri, 21 Oct 2011, Herbert Xu wrote:
> 
> > Hi Linus:
> > 
> > This push fixes a NULL-pointer dereference that can be triggered
> > from user-space.
> > 
> > Please pull from
> > 
> > git://github.com/herbertx/crypto.git
> > 
> 
> Hi Herbert,
> 
> When I pull from this, I also get 
> 
> commit 9c129165af0225c63c37d1896ac9b0d34e48b69f
> Author: Jamie Iles <jamie@jamieiles.com>
> Date:   Mon Jun 6 12:31:17 2011 +0100
> 
>     crypto: picoxcell - fix possible invalid pointer dereference
> 
> which looks unrelated?

Sorry, I seem to have based it on a dirty tree.  It should be
fixed now.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
