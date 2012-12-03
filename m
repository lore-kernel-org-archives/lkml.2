Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2LCPWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:22:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2LCPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:22:13 -0500
Date: Mon, 3 Dec 2012 16:22:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121203152205.GB17093@dhcp22.suse.cz>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
I have glanced through the series and spotten nothing obviously wrong. I
do not feel I could give my r-b because I am not familiar with cpusets
internals enough and some patches looks quite scary (like #8).
Anyway the resulting outcome seems nice.

Thanks!
-- 
Michal Hocko
SUSE Labs
