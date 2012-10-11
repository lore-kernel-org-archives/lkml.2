Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2JKM4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:56:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2JKM4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:56:06 -0400
Date: Thu, 11 Oct 2012 14:56:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4 06/14] memcg: kmem controller infrastructure
Message-ID: <20121011125603.GE29295@dhcp22.suse.cz>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
 <1349690780-15988-7-git-send-email-glommer@parallels.com>
 <20121011124212.GC29295@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011124212.GC29295@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-10-12 14:42:12, Michal Hocko wrote:
[...]
> 	/*
> 	 * Keep reference on memcg while the page is charged to prevent
> 	 * group from vanishing because allocation can outlive their
> 	 * tasks. The reference is dropped in __memcg_kmem_uncharge_page
> 	 */
> 
> please
> > +	mem_cgroup_get(memcg);

Ahh, this will go away. The it doesn't make much sense to add the
comment here.
-- 
Michal Hocko
SUSE Labs
