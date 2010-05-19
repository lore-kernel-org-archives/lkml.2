Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0ESK7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:59:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:47789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0ESK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:59:09 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <20100519010524.GB18813@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 11:58:45 +0100
Message-ID: <1274266725.6930.9823.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 11:05 +1000, Herbert Xu wrote:
> So no getting rid of them isn't going to fix things either.  Of
> course I have no objections to moving this into slab.h or a similar
> location should anyone be willing to do the hard work.

http://git.infradead.org/users/dwmw2/minalign-2.6.git
git://git.infradead.org/users/dwmw2/minalign-2.6.git

Should I include the SPARC patch in that too?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

