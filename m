Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265Ab2CNJsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:48:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44623 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758742Ab2CNJr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:47:57 -0400
Message-ID: <4F6068F4.4090909@parallels.com>
Date: Wed, 14 Mar 2012 13:46:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizf@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC REPOST] cgroup: removing css reference drain wait during
 cgroup removal
References: <20120312213155.GE23255@google.com> <20120312213343.GF23255@google.com> <20120313151148.f8004a00.kamezawa.hiroyu@jp.fujitsu.com> <20120313163914.GD7349@google.com> <20120314092828.3321731c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120314092828.3321731c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 04:28 AM, KAMEZAWA Hiroyuki wrote:
> IIUC, in general, even in the processes are in a tree, in major case
> of servers, their workloads are independent.
> I think FLAT mode is the dafault. 'heararchical' is a crazy thing which
> cannot be managed.

Better pay attention to the current overall cgroups discussions being 
held by Tejun then. ([RFD] cgroup: about multiple hierarchies)

The topic of whether of adapting all cgroups to be hierarchical by 
deafult is a recurring one.

I personally think that it is not unachievable to make res_counters 
cheaper, therefore making this less of a problem.

