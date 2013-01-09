Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3AIJq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:46:58 -0500
Received: from mx2.parallels.com ([64.131.90.16]:52564 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab3AIJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:46:56 -0500
Message-ID: <50ED3C92.1010105@parallels.com>
Date: Wed, 9 Jan 2013 13:46:58 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <paul@paulmenage.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
 take#2
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
In-Reply-To: <1357248967-24959-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 01:35 AM, Tejun Heo wrote:
> Note that this leaves memcg as the only external user of cgroup_mutex.
> Michal, Kame, can you guys please convert memcg to use its own locking
> too?
I've already done this, I just have to rework it according to latest
feedback and repost it.

It should be in the open soon.

