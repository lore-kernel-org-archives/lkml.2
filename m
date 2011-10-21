Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1JUJmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 05:42:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1JUJl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 05:41:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jurfOvn/dW8NMWd22Ogh+oFgAsCQVIG+1HDAs1PDeBvTvInKMVplPODKiYyM3ydJ1
	75bAluUVSbKhcJZheVW8w==
Date: Fri, 21 Oct 2011 02:41:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.1
In-Reply-To: <20111021082259.GA13530@gondor.apana.org.au>
Message-ID: <alpine.DEB.2.00.1110210240290.12963@chino.kir.corp.google.com>
References: <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au>
 <20111021082259.GA13530@gondor.apana.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Herbert Xu wrote:

> Hi Linus:
> 
> This push fixes a NULL-pointer dereference that can be triggered
> from user-space.
> 
> Please pull from
> 
> git://github.com/herbertx/crypto.git
> 

Hi Herbert,

When I pull from this, I also get 

commit 9c129165af0225c63c37d1896ac9b0d34e48b69f
Author: Jamie Iles <jamie@jamieiles.com>
Date:   Mon Jun 6 12:31:17 2011 +0100

    crypto: picoxcell - fix possible invalid pointer dereference

which looks unrelated?
