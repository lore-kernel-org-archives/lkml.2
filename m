Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1KILvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:51:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61972 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1KILvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <1320182360-20043-14-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-14-git-send-email-glommer@parallels.com>
Date: Wed, 9 Nov 2011 14:51:40 +0300
Message-ID: <CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics inside
 cpu cgroup
From: Andrew Wagin <avagin@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Glauber,

> diff --git a/kernel/sched.c b/kernel/sched.c
> index d93cfd4..b9296cd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -303,6 +303,7 @@ struct task_group {
>
>        struct cfs_bandwidth cfs_bandwidth;
>        struct kernel_cpustat __percpu *cpustat;
> +       u64 __percpu *cpuusage;

I can't find where you use this variable, probably it may be removed.
