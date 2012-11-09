Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KIJKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:10:48 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:52849 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2KIJKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:10:39 -0500
Message-ID: <509CC885.9030400@huawei.com>
Date: Fri, 9 Nov 2012 17:10:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <mhocko@suse.cz>, <rjw@sisk.pl>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <fweisbec@gmail.com>
Subject: Re: [PATCH 2/9] cgroup: Use rculist ops for cgroup->children
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-3-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/3 16:38, Tejun Heo wrote:
> Use RCU safe list operations for cgroup->children.  This will be used
> to implement cgroup children / descendant walking which can be used by
> controllers.
> 
> Note that cgroup_create() now puts a new cgroup at the end of the
> ->children list instead of head.  This isn't strictly necessary but is
> done so that the iteration order is more conventional.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Li Zefan <lizefan@huawei.com>

