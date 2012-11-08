Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2KHMoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:44:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2KHMo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:44:28 -0500
Date: Thu, 8 Nov 2012 13:44:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Message-ID: <20121108124426.GF31821@dhcp22.suse.cz>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
 <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
 <alpine.DEB.2.00.1211070956540.27451@chino.kir.corp.google.com>
 <509BA799.505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509BA799.505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-11-12 20:37:45, Sha Zhengju wrote:
> On 11/08/2012 02:02 AM, David Rientjes wrote:
> >On Wed, 7 Nov 2012, Sha Zhengju wrote:
[..]
> >>+	else
> >>+		show_mem(SHOW_MEM_FILTER_NODES);
> >Well that's disappointing if memcg == root_mem_cgroup, we'd probably like
> >to know the global memory state to determine what the problem is.
> >
> 
> I really wondering if there is any case that can pass
> root_mem_cgroup down here.

No it cannot because the root cgroup doesn't have any limit so we cannot
trigger memcg oom killer.

-- 
Michal Hocko
SUSE Labs
