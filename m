Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1EZC6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:58:31 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:43543 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1EZC6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=iIDn4XelOZFiDIaUNfGNDnyDNhigp6kayU160VZfBNRCbO7IMF2KnoqxU/Vadc6TS/
         E+wF5MI1KzTyxBdGMfXRsUiTuQqX1CgRkNXQ7J2LT3KnkNO02HyqGZe1U1t1sQFrZ9No
         bSbZK3FreIBFC+OTvZCnKwLNvmlx6GH8h2z1w=
Date: Thu, 26 May 2011 10:58:08 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: oleg@redhat.com, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signal.c: fix kernel-doc warning
Message-ID: <20110526025806.GA2426@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>, oleg@redhat.com,
	mingo@elte.hu, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20110525192815.01c9227f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110525192815.01c9227f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 07:28:15PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc warnings in signal.c:
> 
> Warning(kernel/signal.c:2374): No description found for parameter 'nset'
> Warning(kernel/signal.c:2374): Excess function parameter 'set' description in 'sys_rt_sigprocmask'
Hi Randy,
	I wonder how you can get the warning of the comments.
IMO, gcc can not get the comments' errors or warnings. Maybe
you just use scripts for this. Would you mind telling me ;)

Thanks
Harry Wei
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
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
>   *  @oset: previous value of signal mask if non-null
>   *  @sigsetsize: size of sigset_t type
>   */
> --
