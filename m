Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0ESTYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:24:17 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:60236 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0ESTYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:24:15 -0400
Date: Wed, 19 May 2010 14:19:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Woodhouse <dwmw2@infradead.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, manfred@colorfullife.com,
       David Miller <davem@davemloft.net>, mpm@selenic.com, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
In-Reply-To: <4BF437EA.9010904@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1005191418520.5729@router.home>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org> <4BF437EA.9010904@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Maybe we can consolidate that into slab.h so that the alignment is the
same for all allocators?

