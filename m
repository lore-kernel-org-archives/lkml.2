Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2EXLnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:43:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54982 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2EXLnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDJ0Bwo_E828bBpz0=G4qb3o6bxBwHaCMhk-GCD5jyfkA@mail.gmail.com>
References: <CAJd=RBDJ0Bwo_E828bBpz0=G4qb3o6bxBwHaCMhk-GCD5jyfkA@mail.gmail.com>
Date: Thu, 24 May 2012 19:43:36 +0800
Message-ID: <CAJd=RBCPN=wFKx7_B5w6AqpMuaJdn8i9HqFJ9ooEFCEzLrxFjA@mail.gmail.com>
Subject: Re: [patch] BFS 420: remove resched_cpu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 8:57 PM, Hillf Danton <dhillf@gmail.com> wrote:
> It is no longer used, so remove.
>
> --- a/kernel/sched/bfs.c        Mon May 14 20:50:38 2012
> +++ b/kernel/sched/bfs.c        Wed May 23 20:07:50 2012
> @@ -4988,14 +4988,6 @@ static inline struct sched_domain *lowes
>
>  #endif /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
>
> -static inline void resched_cpu(int cpu)
> -{
> -       unsigned long flags;
> -
> -       grq_lock_irqsave(&flags);
> -       resched_task(cpu_curr(cpu));
> -       grq_unlock_irqrestore(&flags);
> -}
>
>  /*
>  * In the semi idle case, use the nearest busy cpu for migrating timers
> --
