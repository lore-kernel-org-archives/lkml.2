Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3AGQwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:52:37 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:33770 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3AGQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:52:34 -0500
Date: Mon, 7 Jan 2013 08:52:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cpuset: drop cpuset->stack_list and ->parent, take#2
Message-ID: <20130107165229.GJ3926@htj.dyndns.org>
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
 <50E94392.2050509@huawei.com>
 <20130107164707.GI3926@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107164707.GI3926@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 08:47:07AM -0800, Tejun Heo wrote:
> On Sun, Jan 06, 2013 at 05:27:46PM +0800, Li Zefan wrote:
> > Acked-by: Li Zefan <lizefan@huawei.com>
> 
> I'll route this together with "decouple cpuset locking" patchset in a
> separate branch in cgroup tree.  If anyone objects, please let me
> know.

I put the cgroup_rightmost_descendant() patch in cgroup/for-3.9 and
the rest in cgroup/for-3.9-cpuset.

Thanks.

-- 
tejun
