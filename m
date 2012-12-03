Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2LCQea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:34:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34810 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2LCQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:34:28 -0500
Date: Mon, 3 Dec 2012 08:34:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, lizefan@huawei.com
Subject: Re: [PATCH RESEND] cgroup: remove subsystem files when remounting
 cgroup
Message-ID: <20121203163423.GC19802@htj.dyndns.org>
References: <1354292489-18434-2-git-send-email-gaofeng@cn.fujitsu.com>
 <1354498098-17312-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354498098-17312-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:28:18AM +0800, Gao feng wrote:
> cgroup_clear_directroy is called by cgroup_d_remove_dir
> and cgroup_remount.
> 
> when we call cgroup_remount to remount the cgroup,the subsystem
> may be unlinked from cgroupfs_root->subsys_list in rebind_subsystem,this
> subsystem's files will not be removed in cgroup_clear_directroy.
> And the system will panic when we try to access these files.
> 
> this patch removes subsystems's files before rebind_subsystems,
> if rebind_subsystems failed, repopulate these removed files.
> 
> With help from Tejun.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied to cgroup/for-3.8 with spaces added after commas.

Thanks!

-- 
tejun
