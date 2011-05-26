Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1EZOr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1EZOr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:47:27 -0400
Date: Thu, 26 May 2011 16:45:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] signal.c: fix kernel-doc warning
Message-ID: <20110526144554.GB12525@redhat.com>
References: <20110525192815.01c9227f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525192815.01c9227f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Randy Dunlap wrote:
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix kernel-doc warnings in signal.c
>
> Warning(kernel/signal.c:2374): No description found for parameter 'nset'
> Warning(kernel/signal.c:2374): Excess function parameter 'set' description in 'sys_rt_sigprocmask'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  kernel/signal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.39-git10.orig/kernel/signal.c
> +++ linux-2.6.39-git10/kernel/signal.c
> @@ -2365,7 +2365,7 @@ int sigprocmask(int how, sigset_t *set, 
>  /**
>   *  sys_rt_sigprocmask - change the list of currently blocked signals
>   *  @how: whether to add, remove, or set signals
> - *  @set: stores pending signals
> + *  @nset: stores pending signals

My fault. I changed the name of the argument, but forgot to update the doc.

I'll take this patch, thanks Randy.

Oleg.

