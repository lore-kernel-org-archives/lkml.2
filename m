Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1KKVeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:34:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46272 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1KKVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:34:10 -0500
Message-ID: <4EBD94CE.4050206@google.com>
Date: Fri, 11 Nov 2011 13:34:06 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com
Subject: Re: [PATCH v2 01/14] trivial: initialize root cgroup's sibling list
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-2-git-send-email-glommer@parallels.com>
In-Reply-To: <1320182360-20043-2-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 02:19 PM, Glauber Costa wrote:
> Even though there are no siblings, the list should be
> initialized not to contain bogus values.
>
> Signed-off-by: Glauber Costa<glommer@parallels.com>
> Acked-by: Paul Menage<paul@paulmenage.org>

Signed-off-by: Paul Turner <pjt@google.com>

> ---
>   kernel/sched.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d87c6e5..e327665 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8234,6 +8234,7 @@ void __init sched_init(void)
>   #ifdef CONFIG_CGROUP_SCHED
>   	list_add(&root_task_group.list,&task_groups);
>   	INIT_LIST_HEAD(&root_task_group.children);
> +	INIT_LIST_HEAD(&root_task_group.siblings);
>   	autogroup_init(&init_task);
>   #endif /* CONFIG_CGROUP_SCHED */
>

