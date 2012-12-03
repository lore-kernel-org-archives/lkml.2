Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2LCQxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:53:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36462 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab2LCQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:53:44 -0500
Date: Mon, 3 Dec 2012 08:53:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121203165338.GF19802@htj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <20121203152205.GB17093@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203152205.GB17093@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Dec 03, 2012 at 04:22:05PM +0100, Michal Hocko wrote:
> I have glanced through the series and spotten nothing obviously wrong. I
> do not feel I could give my r-b because I am not familiar with cpusets
> internals enough and some patches looks quite scary (like #8).
> Anyway the resulting outcome seems nice.

Thanks a lot for looking at it and, yeah, it's a bit scary.  Li, Paul,
can you guys please review the series?

Thanks!

-- 
tejun
