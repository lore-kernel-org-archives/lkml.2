Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1I2B24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:28:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60760 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1I2B2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <1316816389-9135-1-git-send-email-glommer@parallels.com>
References: <1316816389-9135-1-git-send-email-glommer@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 28 Sep 2011 18:28:34 -0700
X-Google-Sender-Auth: vxyrNzx2UNbl4mKYf07effXG3gc
Message-ID: <CALdu-PD8GWBFxeCwmEC=FpN53rL5gb=DRkLahi8X8byUBEkqoQ@mail.gmail.com>
Subject: Re: [PATCH] trivial: initialize root cgroup's sibling list
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 3:19 PM, Glauber Costa <glommer@parallels.com> wrote:
> Even though there are no siblings, the list should be
> initialized not to contain bogus values.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Acked-by: Paul Menage <paul@paulmenage.org>

Thanks,
Paul

> ---
>  kernel/sched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..3ed4107 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8082,6 +8082,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_CGROUP_SCHED
>        list_add(&root_task_group.list, &task_groups);
>        INIT_LIST_HEAD(&root_task_group.children);
> +       INIT_LIST_HEAD(&root_task_group.siblings);
>        autogroup_init(&init_task);
>  #endif /* CONFIG_CGROUP_SCHED */
>
> --
> 1.7.6
>
>
