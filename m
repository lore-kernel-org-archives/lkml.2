Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab1CaWIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:08:45 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11005 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1CaWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:08:44 -0400
Message-ID: <4D94FB6A.3050606@caviumnetworks.com>
Date: Thu, 31 Mar 2011 15:08:42 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Aakash Goenka <aakash.goenka@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] kernel: Fix style problems in fork.c
References: <AANLkTi=jHAJ8H0penc8Tkz6w2ihaP3CrkZoQAB9L1G2T@mail.gmail.com>
In-Reply-To: <AANLkTi=jHAJ8H0penc8Tkz6w2ihaP3CrkZoQAB9L1G2T@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2011 22:08:43.0358 (UTC) FILETIME=[32CB87E0:01CBEFF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:48 PM, Aakash Goenka wrote:
>   Fixes most style errors and warnings.

Whatever, but there are some real problems with this that I see.


>   Signed-off-by: Aakash Goenka<aakash.goenka@gmail.com>
>

Should there really be spaces before that SOB?

> ---
>   kernel/fork.c |   96 ++++++++++++++++++++++++++++++++++-----------------------
>   1 files changed, 57 insertions(+), 39 deletions(-)
[...]
>
> -	/* One for us, one for whoever does the "release_task()" (usually parent) */
> -	atomic_set(&tsk->usage,2);
> +	/* One for us, one for whoever does the
> +	 * "release_task()" (usually parent)
> +	 */

Except that change doesn't even follow the guidelines.

> +	atomic_set(&tsk->usage, 2);
>   	atomic_set(&tsk->fs_excl, 0);
>   #ifdef CONFIG_BLK_DEV_IO_TRACE
>   	tsk->btrace_seq = 0;
> @@ -355,7 +357,8 @@ static int dup_mmap(struct mm_struct *mm, struct
> mm_struct *oldmm)
>   		}
>   		charge = 0;
>   		if (mpnt->vm_flags&  VM_ACCOUNT) {
> -			unsigned int len = (mpnt->vm_end - mpnt->vm_start)>>  PAGE_SHIFT;
> +			unsigned int len =
> +			    (mpnt->vm_end - mpnt->vm_start)>>  PAGE_SHIFT;

You have to ask yourself, Is this one really a change for the better?

[...]
>
>   	/* ok, now we should be set up.. */
> -	p->exit_signal = (clone_flags&  CLONE_THREAD) ? -1 : (clone_flags&  CSIGNAL);
> +	p->exit_signal = (clone_flags&  CLONE_THREAD) ?
> +			  -1 : (clone_flags&  CSIGNAL);

Same thing.

.
.
.
