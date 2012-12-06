Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2LFGZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:25:25 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40390 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2LFGZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:25:21 -0500
Message-ID: <50C03A3F.7070605@huawei.com>
Date: Thu, 6 Dec 2012 14:25:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <paul@paulmenage.org>,
        <glommer@parallels.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <peterz@infradead.org>,
        <bsingharora@gmail.com>, <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
References: <1354138460-19286-1-git-send-email-tj@kernel.org> <20121203152205.GB17093@dhcp22.suse.cz> <20121203165338.GF19802@htj.dyndns.org>
In-Reply-To: <20121203165338.GF19802@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/4 0:53, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Dec 03, 2012 at 04:22:05PM +0100, Michal Hocko wrote:
>> I have glanced through the series and spotten nothing obviously wrong. I
>> do not feel I could give my r-b because I am not familiar with cpusets
>> internals enough and some patches looks quite scary (like #8).
>> Anyway the resulting outcome seems nice.
> 
> Thanks a lot for looking at it and, yeah, it's a bit scary.  Li, Paul,
> can you guys please review the series?
> 

We shoudn't haste to target this for 3.8, given that we're in late -rc and
Michal felt some patches scary and they hasn't got enough review.

I'll squeeze time to review them, but currently I've been backlogged with
internal work.

