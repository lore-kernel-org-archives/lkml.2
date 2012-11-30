Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2K3EKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:10:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38600 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab2K3EKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:10:54 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B831BC.3050500@jp.fujitsu.com>
Date: Fri, 30 Nov 2012 13:10:36 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 5/6] memcg: further simplify mem_cgroup_iter
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-6-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-6-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/27 3:47), Michal Hocko wrote:
> mem_cgroup_iter basically does two things currently. It takes care of
> the house keeping (reference counting, raclaim cookie) and it iterates
> through a hierarchy tree (by using cgroup generic tree walk).
> The code would be much more easier to follow if we move the iteration
> outside of the function (to __mem_cgrou_iter_next) so the distinction
> is more clear.
> This patch doesn't introduce any functional changes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Very nice look !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


