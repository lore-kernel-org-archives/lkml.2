Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0JNHRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:17:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:44905 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab0JNHRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:17:18 -0400
Date: Thu, 14 Oct 2010 16:16:52 +0900
To: mitov@issp.bas.bg, kamezawa.hiroyu@jp.fujitsu.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201010131942.57639.mitov@issp.bas.bg>
References: <20101010230323B.fujita.tomonori@lab.ntt.co.jp>
	<20101013170457.c5c5d2e1.kamezawa.hiroyu@jp.fujitsu.com>
	<201010131942.57639.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101014161204I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 14 Oct 2010 16:16:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 19:42:56 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> > > KAMEZAWA posted a patch to improve the generic page allocator to
> > > allocate physically contiguous memory. He said that he can push it
> > > into mainline.
> > > 
> > I said I do make an effort ;)
> > New one here.
> > 
> > http://lkml.org/lkml/2010/10/12/421

Kamezawa, Thanks a lot!!


> I like the patch. The possibility to allocate a contiguous chunk of memory
> (or few of them) is what I need. The next step wilfl be to get a dma handle 
> (for dma transfers to/from) and then mmap them to user space.

Let's help him to push this patch to upstream first. The next step is
a different issue (and the dma stuff isn't even a problem; we can
handle it with the current API).
