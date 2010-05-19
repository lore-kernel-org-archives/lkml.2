Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0ESHPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:15:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:40820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ESHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:15:07 -0400
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
Date: Wed, 19 May 2010 08:14:28 +0100
Message-ID: <1274253269.6930.9325.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 11:05 +1000, Herbert Xu wrote:
> While this problem wouldn't have occurred, we would instead have
> data corruption/alignment faults on architectures such as sparc32
> or ARM that require 64-bit alignment for 64-bit objects.

Yeah, but that's what ARCH_SLAB_MINALIGN is for.

ARM gets this right, and Dave has already said he's going to fix sparc.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

