Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879Ab2KBKWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:22:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51525 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2KBKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:22:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50939EAF.9030907@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 19:21:35 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] memcg: make mem_cgroup_reparent_charges non failing
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-7-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/01 4:44), Tejun Heo wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> Now that pre_destroy callbacks are called from the context where neither
> any task can attach the group nor any children group can be added there
> is no other way to fail from mem_cgroup_pre_destroy.
> mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
> because all css' are marked dead already.
> 
> tj: Remove now unused local variable @cgrp from
>      mem_cgroup_reparent_charges().
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



