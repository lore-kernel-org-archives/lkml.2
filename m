Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2APH46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:56:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab2APH45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:56:57 -0500
Date: Mon, 16 Jan 2012 08:56:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
Message-ID: <20120116075639.GG15641@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326389222.9115.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> /proc/schedstat's second field reflect to # of time context switch happened not # of times switched to the expired queue.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
> index 1cd5d51..7d8e12c 100644
> --- a/Documentation/scheduler/sched-stats.txt
> +++ b/Documentation/scheduler/sched-stats.txt
> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
>       1) # of times sched_yield() was called
>  
>  Next three are schedule() statistics:
> -     2) # of times we switched to the expired queue and reused it
> +     2) # of times context switch happened. This field is not utilized these
> +	days but kept for holding userspace tools integrity.

if it's not used by anything but kept for the ABI then we should 
not put context switch number in there, but always keep it zero, 
right?

Thanks,

	Ingo
