Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0ESSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:11:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:43164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0ESSLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:11:08 -0400
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and
 ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>
From: David Woodhouse <dwmw2@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Johannes Stezenbach <js@sig21.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <4BF427D4.40600@colorfullife.com>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
	 <1274266902.6930.9834.camel@macbook.infradead.org>
	 <20100519133028.GA26659@sig21.net>  <4BF427D4.40600@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 19:10:38 +0100
Message-ID: <1274292638.6930.10394.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 20:03 +0200, Manfred Spraul wrote:
> Is this text better?

Not really...

> * Unless debug options are enabled, the kernel uses cache_line_size() 
> automatically.

... that's a lie.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

