Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3AIOl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:41:59 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:32779 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869Ab3AIOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:41:57 -0500
Date: Wed, 9 Jan 2013 06:41:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Message-ID: <20130109144148.GH3926@htj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357731938-8417-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Jan 09, 2013 at 03:45:27PM +0400, Glauber Costa wrote:
> [ update: I thought I posted this already before leaving for holidays. However,
>   now that I am checking for replies, I can't find nor replies nor the original
>   mail in my boxes or archives. I am posting again for safety sake, but sorry
>   you are getting this twice by any chance ]

I think I saw the series a while back.

> This is an attempt to provide userspace with enough information to reconstruct
> per-container version of files like "/proc/stat". In particular, we are
> interested in knowing the per-cgroup slices of user time, system time, wait
> time, number of processes, and a variety of statistics.
> 
> This task is made more complicated by the fact that multiple controllers are
> involved in collecting those statistics: cpu and cpuacct. So the first thing I
> am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.
> 
> This is one of the major differences from earlier attempts: all data is provided
> by the cpu controller, resulting in greater simplicity.
> 
> This also tries to hook into the existing scheduler hierarchy walks instead of
> providing new ones.

The cgroup part looks good to me.

Thanks.

-- 
tejun
