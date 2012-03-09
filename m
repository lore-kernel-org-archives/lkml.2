Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593Ab2CIUdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:33:42 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40222 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2CIUdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120309202722.GA10323@x61.redhat.com>
References: <CAOJsxLFQjV1c7nQZMA2voybN0AdhGrKFN5svQHC2C=oP3vOD4g@mail.gmail.com>
	<20120309202722.GA10323@x61.redhat.com>
Date: Fri, 9 Mar 2012 22:33:39 +0200
X-Google-Sender-Auth: KyZNajYV0dyhBirUgAo7KyPLELA
Message-ID: <CAOJsxLHX5bU03t32ONDeuT2pq88FLAQpw7DtAxTGL8Qe0_wFzg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: SLAB Out-of-memory diagnostics
From: Pekka Enberg <penberg@kernel.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, David Rientjes <rientjes@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 10:27 PM, Rafael Aquini <aquini@redhat.com> wrote:
> Following the example at mm/slub.c, add out-of-memory diagnostics to the
> SLAB allocator to help on debugging certain OOM conditions.
>
> An example print out looks like this:
>
>  <snip page allocator out-of-memory message>
>  SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
>    cache: bio-0, object size: 192, order: 0
>    node 0: slabs: 3/3, objs: 60/60, free: 0
>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>

David?
