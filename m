Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2FZTIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:08:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53071 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2FZTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:08:43 -0400
Date: Tue, 26 Jun 2012 21:08:25 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120626190825.GF27816@cmpxchg.org>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
 <CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
 <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
 <20120623091752.GK27816@cmpxchg.org>
 <CAE9FiQXYG0=XFAzZStExBTNqdnRPMSjASNydM45GC_G6qfuNkA@mail.gmail.com>
 <20120623220616.GS27816@cmpxchg.org>
 <CAE9FiQWoR_CJd8GD5i5jeFm=_ghUsdTwx8LbP8DnwgdEHo64uQ@mail.gmail.com>
 <20120626081754.GY27816@cmpxchg.org>
 <CAE9FiQWVEDHKeRN3+t39Hch8wpNdjsv15yTyVVLGRdK=yw2n4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWVEDHKeRN3+t39Hch8wpNdjsv15yTyVVLGRdK=yw2n4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:20:16AM -0700, Yinghai Lu wrote:
> On Tue, Jun 26, 2012 at 1:17 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > No use in reverting it, as the bootmem version was already broken
> > before, when the limit was removed in f5bf18f "bootmem/sparsemem:
> > remove limit constraint in alloc_bootmem_section".
> >
> > I'm okay with exporting and using ___alloc_bootmem_node_nopanic() in
> > 3.5.
> 
> Good. Assume that is Acked-by you.

Yes,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, Yinghai!
