Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2LQN6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:58:44 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60459 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2LQN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:58:43 -0500
MIME-Version: 1.0
In-Reply-To: <20121212201529.GD16230@one.firstfloor.org>
References: <1355331819-8728-1-git-send-email-js1304@gmail.com>
	<0000013b90beeb93-87f65a09-0cc3-419f-be26-5271148cb947-000000@email.amazonses.com>
	<20121212201529.GD16230@one.firstfloor.org>
Date: Mon, 17 Dec 2012 22:58:42 +0900
Message-ID: <CAAmzW4P-MT9u_VzJ59t163TFPuDcyNX=tb5sC6WZ8sO20_Zjcg@mail.gmail.com>
Subject: Re: [PATCH] mm: introduce numa_zero_pfn
From: JoonSoo Kim <js1304@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/13 Andi Kleen <andi@firstfloor.org>:
>> I would expect a processor to fetch the zero page cachelines from the l3
>> cache from other sockets avoiding memory transactions altogether. The zero
>> page is likely in use somewhere so no typically no memory accesses should
>> occur in a system.
>
> It depends on how effectively the workload uses the caches. If something
> is a cache pig of the L3 cache, then even shareable cache lines may need
> to be refetched regularly.
>
> But if your workloads spends a significant part of its time reading
> from zero page read only data there is something wrong with the workload.
>
> I would do some data profiling first to really prove that is the case.

Okay.
I didn't know about L3 cache, before.
Now, I think that I need some data profiling!
Thanks for comment.
