Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0JMIKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:10:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57319 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0JMIKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:10:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Oct 2010 17:04:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mitov@issp.bas.bg, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Message-Id: <20101013170457.c5c5d2e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101010230323B.fujita.tomonori@lab.ntt.co.jp>
References: <201008201113.46036.mitov@issp.bas.bg>
	<20100820173349E.fujita.tomonori@lab.ntt.co.jp>
	<201008201450.12585.mitov@issp.bas.bg>
	<20101010230323B.fujita.tomonori@lab.ntt.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 23:08:22 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 20 Aug 2010 14:50:12 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > 
> > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > Helps for videobuf-dma-contig framework.
> > > > > 
> > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > coherent memory for latter usage,
> > > > 
> > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > We use coherent memory because it turns out to be contiguous.
> > > 
> > > Hmm, you don't care about coherency? You just need contiguous memory?
> > 
> > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > transfer finishes user land is able to see the new data. Could be done by something like
> > dma_{,un}map_single()
> 
> Anyone is working on this?
> 
> KAMEZAWA posted a patch to improve the generic page allocator to
> allocate physically contiguous memory. He said that he can push it
> into mainline.
> 
I said I do make an effort ;)
New one here.

http://lkml.org/lkml/2010/10/12/421

Thanks,
-Kame

