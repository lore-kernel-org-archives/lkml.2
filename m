Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2GFJPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:15:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2GFJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:15:16 -0400
Date: Fri, 6 Jul 2012 16:44:15 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Message-ID: <20120706084415.GB9319@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
 <20120706082242.GA1230@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706082242.GA1230@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:22:42AM +0200, Johannes Weiner wrote:
>On Fri, Jul 06, 2012 at 11:44:57AM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.
>
>And nobody is passing anything else.  Which is easy to prove as this
>is a private function.  And there wouldn't even be any harm passing
>something else.  Please don't add stuff like this.

Ok, thank you for your comment.

I also have another two patches, title:

clarify type in memory cgroups
return -EBUSY when oom-kill-disable modified and memcg use_hierarchy, has children

Hopefully, you can review. Thank you Johannes! :-)

Regards,
Wanpeng Li 
