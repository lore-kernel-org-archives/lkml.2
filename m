Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2KIRPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:15:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2KIRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:15:17 -0500
Date: Fri, 9 Nov 2012 09:15:12 -0800
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: implement proper
 hierarchy support
Message-ID: <20121109171512.GA2711@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 01:38:26AM -0700, Tejun Heo wrote:
> Hello,
> 
> This patchset implement proper hierarchy support for cgroup_freezer as
> discussed in "[RFC] cgroup TODOs"[1].

Applied to cgroup/for-3.8.  Rafael, I applied the cgroup_freezer
changes there too as there already are and will be more dependencies
between cgroup_freezer and cgroup changes, and the cgroup_freezer
changes don't really affect the rest of the freezer.  If you'd like
them to be routed differently, please let me know.

Thanks.

-- 
tejun
