Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423235Ab2KNSqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:46:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51914 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423150Ab2KNSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:46:30 -0500
Date: Wed, 14 Nov 2012 10:46:25 -0800
From: Tejun Heo <htejun@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [RFC] rework mem_cgroup iterator
Message-ID: <20121114184625.GE21185@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <50A3C42F.9020901@parallels.com>
 <20121114184110.GD21185@mtj.dyndns.org>
 <50A45729.4000203@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A45729.4000203@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 15, 2012 at 06:44:57AM +0400, Glauber Costa wrote:
> Is there any particular reason why we can't do the other way around
> then, and use a for_each_*() for sched walks? Without even consider what
> I personally prefer, what I really don't like is to have two different
> cgroup walkers when it seems like we could very well have just one.

Ooh, sure thing, let's do that.  Will work on that.

Thanks.

-- 
tejun
