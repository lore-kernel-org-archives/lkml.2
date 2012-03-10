Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2CJIsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 03:48:22 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44909 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2CJIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 03:48:20 -0500
Date: Sat, 10 Mar 2012 10:48:12 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <alpine.DEB.2.00.1203091546360.2419@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1203101046510.1718@tux.localdomain>
References: <20120309202722.GA10323@x61.redhat.com> <alpine.DEB.2.00.1203091546360.2419@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 9 Mar 2012, Rafael Aquini wrote:
> 
> > Following the example at mm/slub.c, add out-of-memory diagnostics to the
> > SLAB allocator to help on debugging certain OOM conditions.
> > 
> > An example print out looks like this:
> > 
> >   <snip page allocator out-of-memory message>
> >   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> >     cache: bio-0, object size: 192, order: 0
> >     node 0: slabs: 3/3, objs: 60/60, free: 0
> > 
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > Acked-by: Rik van Riel <riel@redhat.com>

On Fri, 9 Mar 2012, David Rientjes wrote:
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Thanks for following through with this!

Applied, thanks guys!

			Pekka
