Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab1EMLB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:01:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849Ab1EMLB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:01:28 -0400
Date: Fri, 13 May 2011 13:01:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 5/6] memcg: remove global LRU list
Message-ID: <20110513110124.GF25304@tiehlicka.suse.cz>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
 <1305212038-15445-6-git-send-email-hannes@cmpxchg.org>
 <20110513095348.GE25304@tiehlicka.suse.cz>
 <20110513103608.GP16531@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513103608.GP16531@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 13-05-11 12:36:08, Johannes Weiner wrote:
> On Fri, May 13, 2011 at 11:53:48AM +0200, Michal Hocko wrote:
> > On Thu 12-05-11 16:53:57, Johannes Weiner wrote:
> > > Since the VM now has means to do global reclaim from the per-memcg lru
> > > lists, the global LRU list is no longer required.
> > 
> > Shouldn't this one be at the end of the series?
> 
> I don't really have an opinion.  Why do you think it should?

It is the last step in my eyes and maybe we want to keep both global
LRU as a fallback for some time just to get an impression (with some
tracepoints)how well does the per-cgroup reclaim goes.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
