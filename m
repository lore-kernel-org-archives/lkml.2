Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198Ab2KBJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:56:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51928 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307Ab2KBJ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:56:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509398B1.9090102@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 18:56:01 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] hugetlb: do not fail in hugetlb_cgroup_pre_destroy
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-8-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/31 13:22), Tejun Heo wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> Now that pre_destroy callbacks are called from the context where neither
> any task can attach the group nor any children group can be added there
> is no other way to fail from hugetlb_pre_destroy.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


