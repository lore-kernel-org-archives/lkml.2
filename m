Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2FJGig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 02:38:36 -0400
Received: from ozlabs.org ([203.10.76.45]:49003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab2FJGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 02:38:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Shaw <shaw500@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Shaw <shaw500@gmail.com>
Subject: Re: [PATCH] init: main: Corrected some coding style issues.
In-Reply-To: <1339261575-2318-1-git-send-email-shaw500@gmail.com>
References: <1339261575-2318-1-git-send-email-shaw500@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 10 Jun 2012 16:03:31 +0930
Message-ID: <87oborhe10.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Jun 2012 18:06:15 +0100, Matthew Shaw <shaw500@gmail.com> wrote:
> diff --git a/init/main.c b/init/main.c
> index 1ca6b32..66125f0 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -6,7 +6,7 @@
>   *  GK 2/5/95  -  Changed to support mounting root fs via NFS
>   *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
>   *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
> - *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
> + *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
>   */
>  
>  #include <linux/types.h>
> @@ -148,8 +148,8 @@ static int __init set_reset_devices(char *str)
>  
>  __setup("reset_devices", set_reset_devices);
>  
> -static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
> -const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
> +static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
> +const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
>  static const char *panic_later, *panic_param;
>  
>  extern const struct obs_kernel_param __setup_start[], __setup_end[];
> @@ -464,7 +464,7 @@ static void __init mm_init(void)
>  
>  asmlinkage void __init start_kernel(void)
>  {
> -	char * command_line;
> +	char *command_line;
>  	extern const struct kernel_param __start___param[], __stop___param[];
>  
>  	/*
> @@ -838,7 +838,7 @@ static noinline int init_post(void)
>  	      "See Linux Documentation/init.txt for guidance.");
>  }
>  
> -static int __init kernel_init(void * unused)
> +static int __init kernel_init(void *unused)
>  {
>  	/*
>  	 * Wait until kthreadd is all set-up.

Please send to the trivial patch monkey.

Thanks,
Rusty.
