Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1AGI6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:58:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60238 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1AGI6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:58:49 -0500
Subject: Re: [PATCH] sched: consolidate the name of root_task_group and
 init_task_group
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110107071736.GA32635@windriver.com>
References: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
	 <1294378950.8823.36.camel@marge.simson.net>
	 <20110107071736.GA32635@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 09:59:14 +0100
Message-ID: <1294390754.2016.392.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 15:17 +0800, Yong Zhang wrote:
> Well, I have no bias to either of them. Keeping init_task_group is
> just that we can touch less lines. :)
> 
> If you want root_task_group, here it is:
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] sched: consolidate the name of root_task_group and
> init_task_group
> 
> root_task_group is the leftover of USER_SCHED, now it's always
> same to init_task_group.
> But as Mike suggested, root_task_group is maybe the suitable name
> to keep for a tree.
> So in this patch:
>   init_task_group      --> root_task_group
>   init_task_group_load --> root_task_group_load
>   INIT_TASK_GROUP_LOAD --> ROOT_TASK_GROUP_LOAD
> 
> Suggested-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org> 

OK, took this one instead..
