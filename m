Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2EOJox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:44:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2EOJou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:44:50 -0400
Message-ID: <4FB22589.9050406@gmail.com>
Date: Tue, 15 May 2012 17:44:41 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephane Marchesin <marcheu@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <ffwll.ch@google.com>, Rob Clark <rob.clark@linaro.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] shmem: replace page if mapping excludes its zone
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils> <alpine.LSU.2.00.1205120453210.28861@eggly.anvils> <4FB0C888.8070805@gmail.com> <alpine.LSU.2.00.1205141219340.1623@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205141219340.1623@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 03:42 AM, Hugh Dickins wrote:
> I'm not going to rush the incremental patch to fix this: need to think
> about it quietly first.
>
> If you're wondering what I'm talking about (sorry, I don't have time
> to explain more right now), take a look at comment and git history of
> line 2956 (in 3.4-rc7) of mm/memory.c:
> 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
> I don't suppose anyone ever actually hit the bug in the years before
> we added that protection, but we still ought to guard against it,
> there and here in shmem_replace_page().
>

Ok, I have no objections.

Thanks for your patches anyway!
