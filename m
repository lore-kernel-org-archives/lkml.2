Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2KESjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:39:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab2KESju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:39:50 -0500
Date: Mon, 5 Nov 2012 19:39:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET RESEND v2] cgroup: simplify cgroup removal path
Message-ID: <20121105183947.GA14087@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <20121105173024.GA19354@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105173024.GA19354@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-11-12 09:30:24, Tejun Heo wrote:
> Applied to cgroup/cgroup-rmdir-updates and then pulled into
> cgroup/for-3.8 w/ Li's acks added.

OK, I have merged it into -mm git tree.

Thanks
-- 
Michal Hocko
SUSE Labs
