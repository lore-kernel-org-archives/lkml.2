Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2FYLlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:41:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab2FYLlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:41:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,471,1336320000"; 
   d="scan'208";a="5258684"
Message-ID: <4FE84E53.6070604@cn.fujitsu.com>
Date: Mon, 25 Jun 2012 19:41:07 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 0/2] memcg: cleanup memory cgroup
References: <1340622900-13034-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1340622900-13034-1-git-send-email-liwp.linux@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/25 19:41:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/25 19:41:15,
	Serialize complete at 2012/06/25 19:41:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 07:15 PM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Changelog:
> 
> * drop memcg: move recent_rotated and recent_scanned informations patch
> * drop memcg: replace unsigned long by u64 to avoid overflow
> * not add Add LRU_ALL_UNEVICTABLE
> * drop memcg: cleanup all typo in memory cgroup, if it really need, I will resend in single patch
> * drop memcg: optimize memcg_get_hierarchical_limit 
> 
> Wanpeng Li (2):
> 
> memcg: cleanup useless LRU_ALL_EVICTABLE
> memcg: change mem_control_xxx to mem_cgroup_xxx

You'd be better to send one version of patch set in the same thread.

Thanks,
Wanlong Gao

> 
> ---
>  include/linux/mmzone.h |    1 -
>  mm/memcontrol.c        |   8 +++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 


