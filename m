Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2J2OHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:07:50 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37123 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2J2OHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:07:48 -0400
Message-ID: <508E8DA8.70101@parallels.com>
Date: Mon, 29 Oct 2012 18:07:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 5/6] memcg: make mem_cgroup_reparent_charges non failing
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-6-git-send-email-mhocko@suse.cz>
In-Reply-To: <1351251453-6140-6-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> Now that pre_destroy callbacks are called from the context where neither
> any task can attach the group nor any children group can be added there
> is no other way to fail from mem_cgroup_pre_destroy.
> mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
> because all css' are marked dead already.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Good change.

Reviewed-by: Glauber Costa <glommer@parallels.com>

