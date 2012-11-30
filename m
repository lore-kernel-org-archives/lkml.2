Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2K3JIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:08:48 -0500
Received: from mx2.parallels.com ([64.131.90.16]:59551 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2K3JIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:08:45 -0500
Message-ID: <50B87793.7000104@parallels.com>
Date: Fri, 30 Nov 2012 13:08:35 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 5/6] memcg: further simplify mem_cgroup_iter
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-6-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-6-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:47 PM, Michal Hocko wrote:
> The code would be much more easier to follow if we move the iteration
> outside of the function (to __mem_cgrou_iter_next) so the distinction
> is more clear.
totally nit: Why is it call __mem_cgrou ?

What happened to your p ?

