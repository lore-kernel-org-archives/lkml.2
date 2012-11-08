Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KHOli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:41:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50967 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2KHOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:41:35 -0500
Date: Thu, 8 Nov 2012 06:41:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce
 CGROUP_FREEZING_[SELF|PARENT]
Message-ID: <20121108144130.GE12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-8-git-send-email-tj@kernel.org>
 <509B382E.4030707@jp.fujitsu.com>
 <20121108044521.GH2660@mtj.dyndns.org>
 <509B3B94.1070407@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B3B94.1070407@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kamezawa.

On Thu, Nov 08, 2012 at 01:56:52PM +0900, Kamezawa Hiroyuki wrote:
> Got it, thank you. I'm glad if you add some more explanation in comments
> and considered use-case in changelog.

I explained it in the last patch because it was a bit weird to explain
stuff which isn't implemented yet.  If it doesn't feel sufficient
after the last patch, please let me know.

Thanks.

-- 
tejun
