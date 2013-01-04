Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3ADDng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 22:43:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8031 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3ADDne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 22:43:34 -0500
Message-ID: <50E64FB0.9050803@huawei.com>
Date: Fri, 4 Jan 2013 11:42:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 7/7] cgroup: remove css_get_next
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz> <1357235661-29564-8-git-send-email-mhocko@suse.cz>
In-Reply-To: <1357235661-29564-8-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/4 1:54, Michal Hocko wrote:
> Now that we have generic and well ordered cgroup tree walkers there is
> no need to keep css_get_next in the place.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Li Zefan <lizefan@huawei.com>

> ---
>  include/linux/cgroup.h |    7 -------
>  kernel/cgroup.c        |   49 ------------------------------------------------
>  2 files changed, 56 deletions(-)


