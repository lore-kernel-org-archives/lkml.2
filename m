Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0IJJH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:07:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47420 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0IJJH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sN6oFtxyNp/gCAgPner4yqGytOBjNWRyP15bT+2xSErmRLr0uwYIgLoiZLOMPYDJHq
         /SCrYfyUS1+oohzfShxg==
MIME-Version: 1.0
In-Reply-To: <4C89F47D.20309@kernel.org>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	<1284040322.2589.174.camel@edumazet-laptop>
	<AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
	<1284106566.402.26.camel@laptop>
	<4C89EF37.5080803@kernel.org>
	<AANLkTi=7PJPCwrnK+4ejX7RHC-sautVgK-_+kpoT27k5@mail.gmail.com>
	<4C89F47D.20309@kernel.org>
Date: Fri, 10 Sep 2010 11:07:25 +0200
Message-ID: <AANLkTinP4QJNe9zqTMsW+AuvaMvZoxpwLZ_wL3rqonh=@mail.gmail.com>
Subject: Re: [PATCH] percpu: update comments to reflect that percpu
 allocations are always zero-filled
From: Stephane Eranian <eranian@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks

On Fri, Sep 10, 2010 at 11:03 AM, Tejun Heo <tj@kernel.org> wrote:
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephane Eranian <eranian@google.com>
> ---
>  mm/percpu.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 0cd4bf6..12dea33 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -826,8 +826,8 @@ fail_unlock_mutex:
>  * @size: size of area to allocate in bytes
>  * @align: alignment of area (max PAGE_SIZE)
>  *
> - * Allocate percpu area of @size bytes aligned at @align.  Might
> - * sleep.  Might trigger writeouts.
> + * Allocate zero-filled percpu area of @size bytes aligned at @align.
> + * Might sleep.  Might trigger writeouts.
>  *
>  * CONTEXT:
>  * Does GFP_KERNEL allocation.
> @@ -846,9 +846,10 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
>  * @size: size of area to allocate in bytes
>  * @align: alignment of area (max PAGE_SIZE)
>  *
> - * Allocate percpu area of @size bytes aligned at @align from reserved
> - * percpu area if arch has set it up; otherwise, allocation is served
> - * from the same dynamic area.  Might sleep.  Might trigger writeouts.
> + * Allocate zero-filled percpu area of @size bytes aligned at @align
> + * from reserved percpu area if arch has set it up; otherwise,
> + * allocation is served from the same dynamic area.  Might sleep.
> + * Might trigger writeouts.
>  *
>  * CONTEXT:
>  * Does GFP_KERNEL allocation.
> --
> 1.7.1
>
>
