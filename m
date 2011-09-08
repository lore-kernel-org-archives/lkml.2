Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab1IHA3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:29:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:13332 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab1IHA3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,348,1312182000"; 
   d="scan'208";a="46593110"
Date: Thu, 8 Sep 2011 08:29:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: Add comment explaining task state setting in
 bdi_forker_thread()
Message-ID: <20110908002947.GA9477@localhost>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-3-git-send-email-jack@suse.cz>
 <20110904030551.GB16361@localhost>
 <20110905100141.GA5466@quack.suse.cz>
 <20110905124411.GA794@localhost>
 <20110905155347.GA17354@quack.suse.cz>
 <20110907151936.1d67c706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907151936.1d67c706.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> grammar can often be fixed/improved by deleting stuff ;)
> 
> --- a/mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix
> +++ a/mm/backing-dev.c
> @@ -404,9 +404,8 @@ static int bdi_forker_thread(void *ptr)
>  		/*
>  		 * In the following loop we are going to check whether we have
>  		 * some work to do without any synchronization with tasks
> -		 * waking us up to do work for them. So we have to set task
> -		 * state already here so that we don't miss wakeups coming
> -		 * after we verify some condition.
> +		 * waking us up to do work for them. Set the task state here
> +		 * so that we don't miss wakeups after verifying conditions.
>  		 */
>  		set_current_state(TASK_INTERRUPTIBLE);

That's nice and readable, thanks!

Regards,
Fengguang
