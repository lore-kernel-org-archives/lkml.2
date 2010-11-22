Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0KVJA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:00:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:20126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab0KVJA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:00:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,235,1288594800"; 
   d="scan'208";a="679758329"
From: "Kleen, Andi" <andi.kleen@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        Bob Liu <lliubbo@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "m.nazarewicz@samsung.com" <m.nazarewicz@samsung.com>,
        "pawel@osciak.com" <pawel@osciak.com>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 22 Nov 2010 08:59:57 +0000
Subject: RE: [PATCH 0/4] big chunk memory allocator v4
Thread-Topic: [PATCH 0/4] big chunk memory allocator v4
Thread-Index: AcuILFwXL5r8Gsi2R6+68dJwTzuUDgB9vzIQ
Message-ID: <F4DF93C7785E2549970341072BC32CD796018FCB@irsmsx503.ger.corp.intel.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
 <20101119125653.16dd5452.akpm@linux-foundation.org>
In-Reply-To: <20101119125653.16dd5452.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   But yes, because of fragmentation, this cannot guarantee 100%
> alloc.
> >   If alloc_contig_pages() is called in system boot up or movable_zone
> is used,
> >   this allocation succeeds at high rate.
> 
> So this is an alternatve implementation for the functionality offered
> by Michal's "The Contiguous Memory Allocator framework".

I see them more as orthogonal: Michal's code relies on preallocation
and manages the memory after that.

This code supplies the infrastructure to replace preallocation
with just using movable zones.

-Andi


