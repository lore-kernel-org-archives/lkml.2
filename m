Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2I1OTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:19:43 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47919 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757302Ab2I1OTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:19:42 -0400
Date: Fri, 28 Sep 2012 14:10:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <alpine.DEB.2.00.1209271551220.13360@chino.kir.corp.google.com>
Message-ID: <0000013a0d36b332-44a8ef43-b881-4267-bb4b-f2e441ae185c-000000@email.amazonses.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
 <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com> <alpine.DEB.2.00.1209261810180.7072@chino.kir.corp.google.com> <0000013a0804637a-82ca7649-bc6c-42ef-9a2c-e79b63f47a23-000000@email.amazonses.com>
 <alpine.DEB.2.00.1209271551220.13360@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, David Rientjes wrote:

> No, it's implementation defined so it shouldn't be in kmem_cache_create(),
> it should be in __kmem_cache_create()

The flags are standardized between allocators. We carve out a couple of
bits here that can be slab specific.

> > There *are* multiple slab allocators using those bits! And this works for
> > them. There is nothing too restrictive here. The internal flags are
> > standardized by this patch to be in the highest nibble.
> >
>
> I'm referring to additional slab allocators that will be proposed for
> inclusion shortly.

I am sorry but we cannot consider something that has not been discussed
and publicly reviewed on the mailing list before. We have no way to
understand your rationales at this point and it would take quite some time
to review a new allocator. I would at least have expected the design of
the allocator to be discussed on linux-mm. Nothing of that nature has
happened as far as I can tell.

I think there was a presentation at one of the conference but sadly I was
not able to attend it. I tried to find some details on what was proposed
but so far I have been unsuccessful.

