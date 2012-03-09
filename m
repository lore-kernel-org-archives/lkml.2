Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2CIXqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:46:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60575 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2CIXqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:46:53 -0500
Date: Fri, 9 Mar 2012 15:46:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <20120309202722.GA10323@x61.redhat.com>
Message-ID: <alpine.DEB.2.00.1203091546360.2419@chino.kir.corp.google.com>
References: <20120309202722.GA10323@x61.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Rafael Aquini wrote:

> Following the example at mm/slub.c, add out-of-memory diagnostics to the
> SLAB allocator to help on debugging certain OOM conditions.
> 
> An example print out looks like this:
> 
>   <snip page allocator out-of-memory message>
>   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
>     cache: bio-0, object size: 192, order: 0
>     node 0: slabs: 3/3, objs: 60/60, free: 0
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for following through with this!
