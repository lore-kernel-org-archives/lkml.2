Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3AHBcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:32:13 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:23084 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3AHBcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:32:12 -0500
Message-ID: <50EB76DF.5070508@huawei.com>
Date: Tue, 8 Jan 2013 09:31:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <paul@paulmenage.org>, <glommer@parallels.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
 take#2
References: <1357248967-24959-1-git-send-email-tj@kernel.org> <50E93554.3070102@huawei.com> <20130107164453.GH3926@htj.dyndns.org>
In-Reply-To: <20130107164453.GH3926@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/8 0:44, Tejun Heo wrote:
> Hello, Li.
> 
> On Sun, Jan 06, 2013 at 04:27:00PM +0800, Li Zefan wrote:
>> I've reviewed and tested the patchset, and it looks good to me!
>>
>> Acked-by: Li Zefan <lizefan@huawei.com>
> 
> Great.  Ummm... How should we route this?  Paul doesn't seem to be
> looking at this.  I can route it through cgroup tree.  Any objections?
> 

I don't think Paul's still maintaining cpusets. Normally it's Andrew
that picks up cpuset patches. It's fine you route it through cgroup
tree.

