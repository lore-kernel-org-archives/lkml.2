Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADTwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:52:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:34717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ADTwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dklfVho3iUYlDSjj3x7I9PPHwOVZEAoHVaS9b80MQbfEwdk8uZNqukC9NFrTvDSJJu
         riPIRkO0QkOX90selqgw==
MIME-Version: 1.0
In-Reply-To: <4D22D8EB.1050804@cn.fujitsu.com>
References: <4D22D8EB.1050804@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Tue, 4 Jan 2011 11:52:29 -0800
Message-ID: <AANLkTin7rG5H3zfn6nZzp_bGU9C6r3dOE+8x9WN77bPx@mail.gmail.com>
Subject: Re: [PATCH] cpuset: remove cpuset_unlock()
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, MiaoX <miaox@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 12:23 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> It is not used.
> It is not declared.
> There is no corresponding cpuset_lock().
>
> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks,
Paul

> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 4349935..6ef90dd 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2440,17 +2440,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
>  }
>
>  /**
> - * cpuset_unlock - release lock on cpuset changes
> - *
> - * Undo the lock taken in a previous cpuset_lock() call.
> - */
> -
> -void cpuset_unlock(void)
> -{
> -       mutex_unlock(&callback_mutex);
> -}
> -
> -/**
>  * cpuset_mem_spread_node() - On which node to begin search for a file page
>  * cpuset_slab_spread_node() - On which node to begin search for a slab page
>  *
>
