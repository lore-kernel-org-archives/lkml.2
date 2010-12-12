Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0LLN2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:28:50 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:55496 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab0LLN2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YqJ68n2PA+jTgpoHtSbOke4PZF/6msJPflUUj3zeYk6AWXJjWBBg7kdeo2EwxRDuex
         /rnTmHbUxe6b5VNDLr0aF7ydL7o90W4+NGFwYCuYHMDxsdJgho5B1YTCPyWDNar8+pUv
         zpLfJ/I2gyVA3H3B6l81kr5SX0VgZODuGpaGA=
Date: Sun, 12 Dec 2010 21:28:38 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: bookjovi@gmail.com
Cc: akpm@linux-foundation.org, davem@davemloft.net, mingo@elte.hu,
        eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove invalid comments
Message-ID: <20101212132838.GA2753@darkstar>
References: <1292036796-3051-1-git-send-email-bookjovi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292036796-3051-1-git-send-email-bookjovi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:06:36PM -0500, bookjovi@gmail.com wrote:
> ctl_unnumbered.txt have been removed in Documentation directory
> so just also remove this invalid comments

Please also fix Documentation/sysctl/00-INDEX

> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> 
>  kernel/sysctl.c |   17 -----------------
>  1 files changed, 0 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 5abfa15..108c1d8 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -245,10 +245,6 @@ static struct ctl_table root_table[] = {
>  		.mode		= 0555,
>  		.child		= dev_table,
>  	},
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -963,10 +959,6 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -1327,11 +1319,6 @@ static struct ctl_table vm_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> -
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -1487,10 +1474,6 @@ static struct ctl_table fs_table[] = {
>  		.proc_handler	= &pipe_proc_fn,
>  		.extra1		= &pipe_min_size,
>  	},
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
