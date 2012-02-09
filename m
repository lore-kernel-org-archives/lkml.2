Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2BIXoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:44:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34833 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758437Ab2BIXn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:43:56 -0500
Message-ID: <1328831033.1823.2.camel@joe2Laptop>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>, Xi Wang <xi.wang@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Date: Thu, 09 Feb 2012 15:43:53 -0800
In-Reply-To: <20120209150652.5b1d19dc.akpm@linux-foundation.org>
References: <20120207141155.GA16184@elgon.mountain>
	 <4F323388.7040902@kernel.dk>
	 <20120208142513.4db2493a.akpm@linux-foundation.org>
	 <4F33BF05.208@gmail.com>
	 <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	 <4F33C7D7.1060801@kernel.dk>
	 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com>
	 <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
	 <20120209150652.5b1d19dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 15:06 -0800, Andrew Morton wrote:
> On Thu, 9 Feb 2012 23:47:42 +0100 (CET)
> Jesper Juhl <jj@chaosbits.net> wrote:
> > > -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> > > +static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
> [] 
> > Does this want adding to Documentation/CodingStyle "Chapter 14: Allocating 
> > memory" ?
> 
> Spose so.  We could possibly cook up a checkpatch rule too ;)
> <gad, CodingStyle has 18 chapters and an appendix??>

Symmetry please.

[kv]malloc_array
[kv]malloc_node_array


