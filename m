Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2ENK4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:56:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34944 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2ENK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <4FB0DF4A.5010506@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
	<4FACE01A.4040405@jp.fujitsu.com>
	<20120511141945.c487e94c.akpm@linux-foundation.org>
	<4FB05B8F.8020408@jp.fujitsu.com>
	<CAFTL4hwGEhyxZO0sXx5gVyK_xjhMQEbHojJbHzQmVKafNyVWtw@mail.gmail.com>
	<4FB0DF4A.5010506@jp.fujitsu.com>
Date: Mon, 14 May 2012 12:56:38 +0200
Message-ID: <CAFTL4hzFiFDTUAAgo=1RBLFhG5Xe8VEUESkpc-RgN7L-haMMbA@mail.gmail.com>
Subject: Re: [PATCH 2/6] add res_counter_uncharge_until()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/14 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> There may be some special cases with "Original-patch-from:" tags used when
>> one heavily inspire from a patch without taking much of its original code.
>>
>
>
> Is this ok ?

Yep, or even better since I plan to use my company's address now to
sign my patches:

Signed-off-by: Frederic Weisbecker <fweisbec@redhat.com>

Thanks!
