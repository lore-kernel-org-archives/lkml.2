Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2DRXuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:50:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48300 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab2DRXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:50:51 -0400
X-Sasl-enc: /M/LM5EO6QPewHyqyqTtkFV3MLe66+06gJnMj3clocXY 1334793051
Date: Wed, 18 Apr 2012 16:50:49 -0700
From: Greg KH <greg@kroah.com>
To: anirudh bhat <abhat38@gmail.com>
Cc: arve@android.com, dhowells@redhat.com, chris+android@zenthought.org,
        hpa@zytor.com, devel@driverdev.osuosl.org,
        anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging:android:fix line over 80 characters issue in
 binders.c this patch fixes line over 80 characters warning that was found
 using checkpatch.pl tool Signed-off-by:Anirudh Bhat <abhat38@gmail.com>
Message-ID: <20120418235049.GA5163@kroah.com>
References: <1>
 <1334767915-4870-1-git-send-email-abhat38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334767915-4870-1-git-send-email-abhat38@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:21:55PM +0530, anirudh bhat wrote:
> From: anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
> 

Where is patch 1/2?

I need a signed-off line in the patch.

I see the problem (you forgot to put an extra line after the first line
in your git commit), but that doesn't explain where the From: line came
from, that's a new one to me.


> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index c283212..ae341e0 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -644,8 +644,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		goto free_range;
>  
>  	if (vma == NULL) {
> -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> -		       "map pages in userspace, no vma\n", proc->pid);
> +		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> +			proc->pid);

No, breaking up printk lines is not acceptable, sorry, we don't take
that kind of patch for cleanups at all.

greg k-h
