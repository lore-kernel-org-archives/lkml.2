Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2F0Iqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:46:30 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39500 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab2F0Iq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:46:29 -0400
Message-ID: <4FEAC7C6.7030601@parallels.com>
Date: Wed, 27 Jun 2012 12:43:50 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 04:16 AM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> Changelog:
>
> V2 -> V1:
>
> * replace memory_cgroup_xxx by memcg_xxx
>
> Unify memcg functions to memcg_xxx.


This patch achieves nothing.
You're changing a couple of function names. Andrew stated goal was to 
change *all* function names from mem_cgroup_xxx to memcg_xxx, not just 
one or two.

This can be done mechanically by replacing occurrences of mem_cgroup_xxx 
with memcg_xxx, and verifying that your final result is correct by 
compiling the kernel with and without the combination of config options 
that matters here, plus a set of randconfigs - or anything like that.

Make sure you have Andrew's latest patch in your tree, that converts the 
config option names.


