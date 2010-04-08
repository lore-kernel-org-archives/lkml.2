Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0DHDxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:53:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42262 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab0DHDxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:53:04 -0400
Date: Thu, 8 Apr 2010 04:52:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pauli Nieminen <suokkos@gmail.com>, Jerome Glisse <jglisse@redhat.com>
Subject: Re: linux-next: build failure after merge of the drm tree
In-Reply-To: <20100408131251.b69e2fa2.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1004080452150.11948@skynet.skynet.ie>
References: <20100408131251.b69e2fa2.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'ttm_page_pool_free':
> drivers/gpu/drm/ttm/ttm_page_alloc.c:311: error: implicit declaration of function 'kmalloc'
> drivers/gpu/drm/ttm/ttm_page_alloc.c:312: warning: assignment makes pointer from integer without a cast
> drivers/gpu/drm/ttm/ttm_page_alloc.c:375: error: implicit declaration of function 'kfree'
> drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'ttm_alloc_new_pages':
> drivers/gpu/drm/ttm/ttm_page_alloc.c:483: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit 1403b1a38e8b19a4cc17e2c158e278628943a436 ("drm/ttm: add
> pool wc/uc page allocator V3") interacting with the removal of slab.h
> from percpu.h.
> 
> I applied the following patch for today.

Thanks Stephen,

applied for next drm-next.

Dave.
