Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab2D0XsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:48:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59277 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2D0XsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120427181642.GG26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<20120427181642.GG26595@google.com>
Date: Sat, 28 Apr 2012 08:48:18 +0900
Message-ID: <CABEgKgrir3PBGqm_9FmYsZTiFqsZ=Cdt5iZDu5WcOHPtZuEbFg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 3:16 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Apr 27, 2012 at 02:45:30PM +0900, KAMEZAWA Hiroyuki wrote:
>> This is a v2 patch for preventing failure in memcg->pre_destroy().
>> With this patch, ->pre_destroy() will never return error code and
>> users will not see warning at rmdir(). And this work will simplify
>> memcg->pre_destroy(), largely.
>>
>> This patch is based on linux-next + hugetlb memory control patches.
>
> Ergh... can you please set up a git branch somewhere for review
> purposes?
>
I'm sorry...I can't. (To do that, I need to pass many my company's check.)
I'll repost all a week later, hugetlb tree will be seen in memcg-devel or
linux-next.

Thanks,
-Kame
