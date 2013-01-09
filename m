Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3AITck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:32:40 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58810 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3AITcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:32:39 -0500
MIME-Version: 1.0
In-Reply-To: <50EB76DF.5070508@huawei.com>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
 <50E93554.3070102@huawei.com> <20130107164453.GH3926@htj.dyndns.org> <50EB76DF.5070508@huawei.com>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 9 Jan 2013 11:32:18 -0800
X-Google-Sender-Auth: 3Vk6o65x8EWJ4rCOWJuYh2q57hE
Message-ID: <CALdu-PCmeXNF7FCVstVBNRzQDgkhBAPnWs0Czt9HOHZ4mT68-A@mail.gmail.com>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core, take#2
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 5:31 PM, Li Zefan <lizefan@huawei.com> wrote:
>
> I don't think Paul's still maintaining cpusets. Normally it's Andrew
> that picks up cpuset patches. It's fine you route it through cgroup
> tree.

Yes, I'm sorry - I should have handed on cpusets at the time I had to
hand on cgroups. I was only really ever the maintainer for cpusets
because Paul Jackson asked me to take it over when he retired, as I
understood the cgroups-related parts of it. I never really had a good
grasp of how the some of the lower-level parts of it interacted with
the rest of the system (e.g. offlining, CPUs, scheduler domains, etc)
anyway ...

Paul
