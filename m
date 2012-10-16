Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2JPMLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:11:52 -0400
Received: from ozlabs.org ([203.10.76.45]:33097 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2JPMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:11:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Russell <giles.alex@hotmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lguest: fix typo
In-Reply-To: <1350299536-22316-1-git-send-email-giles.alex@hotmail.com>
References: <1350299536-22316-1-git-send-email-giles.alex@hotmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 16 Oct 2012 20:01:32 +1030
Message-ID: <87bog24vbf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Russell <giles.alex@hotmail.com> writes:
> Signed-off-by: Alex Russell <giles.alex@hotmail.com>
> ---
>  drivers/lguest/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
> index b5fdcb7..a5ebc00 100644
> --- a/drivers/lguest/core.c
> +++ b/drivers/lguest/core.c
> @@ -225,7 +225,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
>  			 * eventfd (ie. the appropriate virtqueue thread)?
>  			 */
>  			if (!send_notify_to_eventfd(cpu)) {
> -				/* OK, we tell the main Laucher. */
> +				/* OK, we tell the main Launcher. */
>  				if (put_user(cpu->pending_notify, user))
>  					return -EFAULT;
>  				return sizeof(cpu->pending_notify);
> -- 
> 1.7.9.5

Applied!

Thanks,
Rusty.
