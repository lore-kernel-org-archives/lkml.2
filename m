Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2KMAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:55:49 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34133 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab2KMAzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:55:47 -0500
Date: Mon, 12 Nov 2012 19:55:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/4] bootmem: remove alloc_arch_preferred_bootmem()
Message-ID: <20121113005543.GC10092@cmpxchg.org>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
 <1352737915-30906-3-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352737915-30906-3-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:31:54AM +0900, Joonsoo Kim wrote:
> The name of function is not suitable for now.
> And removing function and inlining it's code to each call sites
> makes code more understandable.
> 
> Additionally, we shouldn't do allocation from bootmem
> when slab_is_available(), so directly return kmalloc*'s return value.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
