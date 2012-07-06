Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2GFQ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:58:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33238 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2GFQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:58:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120706155920.GA7721@barrios>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<20120706155920.GA7721@barrios>
Date: Sat, 7 Jul 2012 01:58:24 +0900
Message-ID: <CAAmzW4N+-xS65-NDJF2V9nzGDBTFC=20sZ8LJx5wCZ8=t7SpTQ@mail.gmail.com>
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
From: JoonSoo Kim <js1304@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/7 Minchan Kim <minchan@kernel.org>:
> Hi Joonsoo,
>
> On Sat, Jul 07, 2012 at 12:28:41AM +0900, Joonsoo Kim wrote:
>> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
>
> It's already slow path so it's pointless for such optimization.

I know this is so minor optimization.
But why don't we do such a one?
Is there any weak point?

>> And in almost invoking case, order is 0, so return immediately.
>
> You can't make sure it.

Okay.

>>
>> Let's not invoke it when order 0
>
> Let's not ruin git blame.

Hmm...
When I do git blame, I can't find anything related to this.

Thanks for comments.
