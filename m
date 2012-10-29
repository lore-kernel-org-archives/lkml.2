Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab2J2Ukr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:40:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55287 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621Ab2J2Ukl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:40:41 -0400
Date: Mon, 29 Oct 2012 13:40:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [V5 PATCH 08/26] memcontrol: use N_MEMORY instead
 N_HIGH_MEMORY
In-Reply-To: <20121029162212.GE20757@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210291340100.18552@chino.kir.corp.google.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com> <1351524078-20363-7-git-send-email-laijs@cn.fujitsu.com> <20121029162212.GE20757@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Michal Hocko wrote:

> > N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> > N_MEMORY stands for the nodes that has any memory.
> 
> What is the difference of those two?
> 

Patch 5 in the series introduces it to be equal to N_HIGH_MEMORY, so 
accepting this patch would be an implicit ack of the direction taken 
there.
