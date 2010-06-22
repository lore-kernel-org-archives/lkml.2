Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0FVSpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:45:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36067 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0FVSpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:45:53 -0400
Date: Tue, 22 Jun 2010 20:45:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/25] lmb: Prepare to include linux/lmb.h in core file
Message-ID: <20100622184550.GA25947@merkur.ravnborg.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277227614-11581-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:26:34AM -0700, Yinghai Lu wrote:
> Need to add protection in linux/lmb.h, to prepare to include it in
>  mm/page_alloc.c and mm/bootmem.c etc.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index eb8a5a3..d529232 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_LMB_H
>  #ifdef __KERNEL__
>  
> +#ifdef CONFIG_HAVE_LMB

The file could loose the "#ifdef __KERNEL__"
as lmb.h is not exported to userspace.

	Sam
