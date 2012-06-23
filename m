Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2FWJwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:52:01 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52399 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2FWJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:51:59 -0400
Date: Sat, 23 Jun 2012 11:51:13 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] memcg: move recent_rotated and recent_scanned
 informations
Message-ID: <20120623095112.GO27816@cmpxchg.org>
References: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 02:17:39PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Move recent_rotated and recent_scanned prints next to inactive_anon,
> ative_anon, inactive_file, active_file, and unevictable prints to
> save developers' time. Since they have to go a long way(when cat memory.stat)
> to find recent_rotated and recent_scanned prints which has relationship
> with the memory cgroup we care. These prints are behind total_* which
> not just focus on the memory cgroup we care currently.

The hierarchical stats are about that memcg, too.  And I don't want to
turn on debugging and then look for the extra information hiding in
the middle of regular stats.
