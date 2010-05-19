Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0EST2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:28:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:41157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0EST22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:28:28 -0400
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and
 ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Herbert Xu <herbert@gondor.hengli.com.au>, manfred@colorfullife.com,
       David Miller <davem@davemloft.net>, mpm@selenic.com, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <alpine.DEB.2.00.1005191418520.5729@router.home>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
	 <1274266902.6930.9834.camel@macbook.infradead.org>
	 <4BF437EA.9010904@cs.helsinki.fi>
	 <alpine.DEB.2.00.1005191418520.5729@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 20:28:03 +0100
Message-ID: <1274297283.6930.10476.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 14:19 -0500, Christoph Lameter wrote:
> 
> Maybe we can consolidate that into slab.h so that the alignment is the
> same for all allocators? 

Doing so at least for slub and slab would make sense. I wanted to move
them first though, as a separate step.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

