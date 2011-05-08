Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1EHVaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab1EHVaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:30:19 -0400
Message-ID: <4DC70B45.3020503@redhat.com>
Date: Sun, 08 May 2011 17:29:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, walken@google.com,
        aarcange@redhat.com, hughd@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: memory: remove unreachable code
References: <20110508211834.GA4410@maxin>
In-Reply-To: <20110508211834.GA4410@maxin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2011 05:18 PM, Maxin B John wrote:
> Remove the unreachable code found in mm/memory.c
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/mm/memory.c b/mm/memory.c
> index 27f4253..d3b30af 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3695,7 +3695,6 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
>   			if (ret<= 0)
>   #endif
>   				break;
> -			bytes = ret;
>   		} else {
>   			bytes = len;
>   			offset = addr&  (PAGE_SIZE-1);

Is it really impossible for vma->vm_ops->access to return a
positive value?

-- 
All rights reversed
