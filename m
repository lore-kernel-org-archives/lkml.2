Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1CHVuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:50:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1CHVuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YgWkZtix39BxVNTuwixPtQ80Ias/qVUq6Ohere+0w7t6AB+VGd0yJjQfBhd+7U4yn/
         LJvarudS3AQncVw2wIEA==
MIME-Version: 1.0
In-Reply-To: <1299459180-11321-2-git-send-email-leemgs1@gmail.com>
References: <1299459180-11321-1-git-send-email-leemgs1@gmail.com> <1299459180-11321-2-git-send-email-leemgs1@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 8 Mar 2011 13:49:56 -0800
Message-ID: <AANLkTi=FYHX3Z1zAi5BqHqxRSQK-iOJ+tSvZwj4csZ=2@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] cgroup:doc Update cpuset info & webiste via cgroup.
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 4:52 PM, Geunsik Lim <leemgs1@gmail.com> wrote:
> cpuset website is changed.
> and, update list of cpuset using cgroup(controller group).
>
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>

Acked-by: Paul Menage <menage@google.com>

You should forward these to Andew Morton for the -mm tree.

Paul

> ---
>  Documentation/cgroups/cpusets.txt |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 5d0d569..98a3082 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -693,7 +693,7 @@ There are ways to query or modify cpusets:
>  - via the C library libcgroup.
>    (http://sourceforge.net/projects/libcg/)
>  - via the python application cset.
> -   (http://developer.novell.com/wiki/index.php/Cpuset)
> +   (http://code.google.com/p/cpuset/)
>
>  The sched_setaffinity calls can also be done at the shell prompt using
>  SGI's runon or Robert Love's taskset.  The mbind and set_mempolicy
> @@ -725,13 +725,14 @@ Now you want to do something with this cpuset.
>
>  In this directory you can find several files:
>  # ls
> -cpuset.cpu_exclusive       cpuset.memory_spread_slab
> -cpuset.cpus                cpuset.mems
> -cpuset.mem_exclusive       cpuset.sched_load_balance
> -cpuset.mem_hardwall        cpuset.sched_relax_domain_level
> -cpuset.memory_migrate      notify_on_release
> -cpuset.memory_pressure     tasks
> -cpuset.memory_spread_page
> +cgroup.clone_children  cpuset.memory_pressure
> +cgroup.event_control   cpuset.memory_spread_page
> +cgroup.procs           cpuset.memory_spread_slab
> +cpuset.cpu_exclusive   cpuset.mems
> +cpuset.cpus            cpuset.sched_load_balance
> +cpuset.mem_exclusive   cpuset.sched_relax_domain_level
> +cpuset.mem_hardwall    notify_on_release
> +cpuset.memory_migrate  tasks
>
>  Reading them will give you information about the state of this cpuset:
>  the CPUs and Memory Nodes it can use, the processes that are using
> --
> 1.6.2.5
>
>
