Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1CETMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:12:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12041 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1CETMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:12:03 -0500
Date: Sat, 5 Mar 2011 20:11:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCHv2 02/24] sys_swapon: remove changelog from function
 comment
In-Reply-To: <1299343345-3984-3-git-send-email-cesarb@cesarb.net>
Message-ID: <alpine.LNX.2.00.1103052008510.32044@swampdragon.chaosbits.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net> <1299343345-3984-3-git-send-email-cesarb@cesarb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Cesar Eduardo Barros wrote:

> Changelogs belong in the git history instead of in the source code.
> 
> Also, "The swapon system call" is redundant with
> "SYSCALL_DEFINE2(swapon, ...)".
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>
> ---
>  mm/swapfile.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3fe8913..75ee39c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1844,11 +1844,6 @@ static int __init max_swapfiles_check(void)
>  late_initcall(max_swapfiles_check);
>  #endif
>  
> -/*
> - * Written 01/25/92 by Simmule Turner, heavily changed by Linus.
> - *
> - * The swapon system call
> - */

Second line in the comment can hardly be called "changelog".

Removing the comment won't break anything, so

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

