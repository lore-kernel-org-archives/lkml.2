Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2D0Xvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:51:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42094 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab2D0Xvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120427181840.GH26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A343F.7020409@jp.fujitsu.com>
	<20120427181840.GH26595@google.com>
Date: Sat, 28 Apr 2012 08:51:42 +0900
Message-ID: <CABEgKgrqW++YxikPC4tzHA6Yad0YZx7fqfdaYQHXixF+eB6Bjw@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 3:18 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 27, 2012 at 02:53:03PM +0900, KAMEZAWA Hiroyuki wrote:
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index d508363..f4ec411 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -66,6 +66,8 @@ done:
>>       return ret;
>>  }
>>
>> +
>> +
>
> Contamination?

Ah, sorry. I'll fix.

-Kame
