Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2ITSBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:01:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47846 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2ITSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:01:04 -0400
Date: Thu, 20 Sep 2012 11:00:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, lizefan@huawei.com, peterz@infradead.org,
        mhocko@suse.cz, kay.sievers@vrfy.org, mzxreary@0pointer.de,
        davej@redhat.com, ben@decadent.org.uk, pjt@google.com
Subject: Re: [PATCH 2/3] cgroup, sched: let cpu serve the same files as
 cpuacct
Message-ID: <20120920180049.GG28934@google.com>
References: <1348094625-4471-1-git-send-email-tj@kernel.org>
 <1348094625-4471-3-git-send-email-tj@kernel.org>
 <505ACE36.80603@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505ACE36.80603@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell, Glauber.

On Thu, Sep 20, 2012 at 12:05:10PM +0400, Glauber Costa wrote:
> The whole point of this merge is that this is not needed.

Yeah, the whole point of this series is enabling that and other
optimizations.

> This information is already available from exec_clock for fair tasks.
> for rt tasks, we have no exec clock, but do have a hierarchy walk a bit
> below the current cpuacct charge, that can be used for that purpose.

Yeah yeah, sure, now you can build that on top of this patchset
without worrying about cpuacct, which can also, hopefully, be removed
fairly soon.

Thanks.

-- 
tejun
