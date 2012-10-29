Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593Ab2J2Vxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:53:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:49903 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761422Ab2J2Vxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:53:38 -0400
Date: Mon, 29 Oct 2012 14:53:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121029215336.GA13740@kroah.com>
References: <20121025192510.GA26600@kroah.com>
 <1351239859-6585-1-git-send-email-unmole.in@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351239859-6585-1-git-send-email-unmole.in@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:54:19PM +0530, Anmol Sarma wrote:
>  	if (vma == NULL) {
> -		pr_err("binder: %d: binder_alloc_buf failed to "
> -		       "map pages in userspace, no vma\n", proc->pid);
> +		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> +		 proc->pid);
>  		goto err_no_vma;
>  	}
>  
> @@ -585,8 +587,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		BUG_ON(*page);
>  		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
>  		if (*page == NULL) {
> -			pr_err("binder: %d: binder_alloc_buf failed "
> -			       "for page at %p\n", proc->pid, page_addr);
> +			pr_err("%d: binder_alloc_buf failed for page at %p\n",
> +			 proc->pid, page_addr);
>  			goto err_alloc_page_failed;
>  		}
>  		tmp_area.addr = page_addr;

What's with the very wierd indentation here for the second line?  Please
indent it properly, one space isn't ok.

greg k-h
