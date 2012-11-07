Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2KGRCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:02:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39860 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2KGRCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:02:30 -0500
Date: Wed, 7 Nov 2012 09:02:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9] cgroup: add cgroup_subsys->post_create()
Message-ID: <20121107170221.GE2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <20121107152516.GA4131@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107152516.GA4131@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 07, 2012 at 04:25:16PM +0100, Michal Hocko wrote:
> > This patch adds ->post_create().  It's called after all ->create()
> > succeeded and the cgroup is linked into the generic cgroup hierarchy.
> > This plays the counterpart of ->pre_destroy().
> 
> Hmm, I had to look at "cgroup_freezer: implement proper hierarchy
> support" to actually understand what is the callback good for. The above
> sounds as if the callback is needed when a controller wants to use
> the new iterators or when pre_destroy is defined.
> 
> I think it would be helpful if the changelog described that the callback
> is needed when the controller keeps a mutable shared state for the
> hierarchy. For example memory controller doesn't have any such a strict
> requirement so we can safely use your new iterators without pre_destroy.

Hmm.... will try to explain it but I think it might be best to just
refer to the later patch for details.  It's a bit tricky to explain.

Thanks.

-- 
tejun
