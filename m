Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423528Ab2LFNJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:09:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2LFNJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:09:10 -0500
Date: Thu, 6 Dec 2012 14:09:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121206130904.GC10931@dhcp22.suse.cz>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <20121203152205.GB17093@dhcp22.suse.cz>
 <20121203165338.GF19802@htj.dyndns.org>
 <50C03A3F.7070605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C03A3F.7070605@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-12-12 14:25:03, Li Zefan wrote:
> On 2012/12/4 0:53, Tejun Heo wrote:
> > Hello, Michal.
> > 
> > On Mon, Dec 03, 2012 at 04:22:05PM +0100, Michal Hocko wrote:
> >> I have glanced through the series and spotten nothing obviously wrong. I
> >> do not feel I could give my r-b because I am not familiar with cpusets
> >> internals enough and some patches looks quite scary (like #8).
> >> Anyway the resulting outcome seems nice.
> > 
> > Thanks a lot for looking at it and, yeah, it's a bit scary.  Li, Paul,
> > can you guys please review the series?
> > 
> 
> We shoudn't haste to target this for 3.8, given that we're in late -rc and
> Michal felt some patches scary and they hasn't got enough review.

Well, even the original code is scary enough so if the decision should
be made just based on my feeling then it would be too sensitive
probably. Anyway I do agree that the series should see review from
others who are more familiar with the code before considering for
merging.
-- 
Michal Hocko
SUSE Labs
