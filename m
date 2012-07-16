Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2GPFf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:35:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2GPFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:35:25 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-6e-5003a81b30e0
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/debug: Fix printing format of next_balance
References: <1341325149-3791-1-git-send-email-namhyung@kernel.org>
Date: Mon, 16 Jul 2012 14:30:22 +0900
In-Reply-To: <1341325149-3791-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 3 Jul 2012 23:19:09 +0900")
Message-ID: <87ipdo2ryp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping. :)

On Tue,  3 Jul 2012 23:19:09 +0900, Namhyung Kim wrote:
> Use P() for the next_balance since it's in jiffies not nsec.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/sched/debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index c09a4e79f5d0..a408a17a1d33 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -280,7 +280,7 @@ do {									\
>  	P(nr_switches);
>  	P(nr_load_updates);
>  	P(nr_uninterruptible);
> -	PN(next_balance);
> +	P(next_balance);
>  	P(curr->pid);
>  	PN(clock);
>  	P(cpu_load[0]);
