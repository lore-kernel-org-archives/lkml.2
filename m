Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2KHDBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 22:01:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54782 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab2KHDBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 22:01:42 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B2082.1090402@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 12:01:22 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 2/9] cgroup: Use rculist ops for cgroup->children
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-3-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/03 17:38), Tejun Heo wrote:
> Use RCU safe list operations for cgroup->children.  This will be used
> to implement cgroup children / descendant walking which can be used by
> controllers.
>
> Note that cgroup_create() now puts a new cgroup at the end of the
> ->children list instead of head.  This isn't strictly necessary but is
> done so that the iteration order is more conventional.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


