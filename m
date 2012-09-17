Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2IQBKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:10:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3494 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2IQBKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:10:36 -0400
Message-ID: <50567834.9050502@huawei.com>
Date: Mon, 17 Sep 2012 09:09:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Aristeu Rozanski <aris@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        <akpm@linux-foundation.org>, <jirislaby@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix invalid rcu dereference
References: <5052F78A.7010007@suse.cz> <1347615612-11450-1-git-send-email-jslaby@suse.cz> <20120914132738.GN19694@redhat.com> <20120914170147.GB17747@google.com>
In-Reply-To: <20120914170147.GB17747@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/9/15 1:01, Tejun Heo wrote:
> On Fri, Sep 14, 2012 at 09:27:38AM -0400, Aristeu Rozanski wrote:
>> On Fri, Sep 14, 2012 at 11:40:12AM +0200, Jiri Slaby wrote:
>>> Commit "device_cgroup: convert device_cgroup internally to policy +
>>> exceptions" removed rcu locks which are needed in task_devcgroup
>>> called in this chain: devcgroup_inode_mknod OR
>>> __devcgroup_inode_permission -> __devcgroup_inode_permission ->
>>> task_devcgroup -> task_subsys_state -> task_subsys_state_check.
>>
>> ugh, missed that
>>
> ...
>> thanks Jiri
>> Acked-by: Aristeu Rozanski <aris@redhat.com>
> 
> How should this be routed?
> 

through akpm's -mm tree.

