Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946116Ab2LFQyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:54:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58555 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2LFQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:54:32 -0500
Date: Thu, 6 Dec 2012 08:54:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121206165426.GM19802@htj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <20121203152205.GB17093@dhcp22.suse.cz>
 <20121203165338.GF19802@htj.dyndns.org>
 <50C03A3F.7070605@huawei.com>
 <20121206130904.GC10931@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206130904.GC10931@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Thu, Dec 06, 2012 at 02:09:04PM +0100, Michal Hocko wrote:
> > We shoudn't haste to target this for 3.8, given that we're in late -rc and
> > Michal felt some patches scary and they hasn't got enough review.
> 
> Well, even the original code is scary enough so if the decision should
> be made just based on my feeling then it would be too sensitive
> probably. Anyway I do agree that the series should see review from
> others who are more familiar with the code before considering for
> merging.

It's already too late for 3.8.  All cpuset changes are for 3.9.

Thanks.

-- 
tejun
