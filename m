Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2CTJoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:44:06 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39913 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2CTJoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:44:04 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -V4 07/10] hugetlbfs: Add memcg control files for hugetlbfs
In-Reply-To: <4F66E169.5000909@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A059.20801@jp.fujitsu.com> <87wr6hjc58.fsf@linux.vnet.ibm.com> <4F66E169.5000909@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Mar 2012 14:52:20 +0530
Message-ID: <874ntjtynn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12032009-5816-0000-0000-000001D448E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

>
> O.K. BTW, please read Tejun's recent post..
>
> https://lkml.org/lkml/2012/3/16/522
>
> Can you use his methods ?
>
> I guess you can write...
>
> CGROUP_SUBSYS_CFTYLES_COND(mem_cgroup_subsys,
> 			hugetlb_cgroup_files,
> 			if XXXXMB hugetlb is allowed);
>

I may not be able to do CGROUP_SUBSYS_CFTYPES_COND(). But as long as we
are able to dynamically add new control files, we should be ok.

-aneesh

