Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab2CaQbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 12:31:06 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61459 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2CaQbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 12:31:02 -0400
Date: Sat, 31 Mar 2012 09:30:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Message-ID: <20120331163056.GA2557@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <4F75AA1F.9020007@huawei.com>
 <20120330154246.GE28934@google.com>
 <4F76FF04.40007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F76FF04.40007@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Mar 31, 2012 at 08:56:36PM +0800, Li Zefan wrote:
> > Subsys can't be changed if any non-root cgroup exists.
> 
> Ah, this is a long-standing defect, which is documented in Doc/../cgroups.txt.
> It's not trivial to fix it, and I never heard someone request it to be fixed.

Yeah, it was a bit of head scratcher.  If it can be done only when
there's no cgroup configured, one might as well unmount and mount w/
new subsys instead of remounting.  There's the minute difference that
existing root cgroup state is preserved but that hardly justifies the
crippled feature.  IMHO, lack of fix request indicates the feature not
being used rather than anything else, so the deprecation proposal.

Thanks.

-- 
tejun
