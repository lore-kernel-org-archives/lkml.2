Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2FOGVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:21:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54582 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2FOGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:21:01 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 09/15] mm/hugetlb: Add new HugeTLB cgroup
In-Reply-To: <4FD9A6B6.50503@huawei.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD9A6B6.50503@huawei.com>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 15 Jun 2012 11:50:52 +0530
Message-ID: <87mx45m6yj.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061506-5816-0000-0000-000003289056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizefan@huawei.com> writes:

>> +static inline
>
>> +struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
>> +{
>> +	if (s)
>
>
> Neither cgroup_subsys_state() or task_subsys_state() will ever return NULL,
> so here 's' won't be NULL.
>

That is a change that didn't get updated when i dropped page_cgroup
changes. I had a series that tracked in page_cgroup
cgroup_subsys_state. I will send an fix on top.

Thanks for the review.
-aneesh

