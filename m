Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab2HQPkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:40:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37655 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274Ab2HQPj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:39:58 -0400
Subject: Re: [RFC PATCH 0/1] sched: Add a new API to find the prefer idlest
 cpu
From: Shirley Ma <mashirle@us.ibm.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org
Cc: netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        vivek@us.ibm.com, sri@us.ibm.com, sri@us.ibm.com
In-Reply-To: <1343026634.13461.15.camel@oc3660625478.ibm.com>
References: <1343026634.13461.15.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Aug 2012 08:39:46 -0700
Message-ID: <1345217986.16533.1.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081715-5806-0000-0000-00001880C28A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo, Peter,

	Have you had chance to review below patch?

Thanks
Shirley

On Sun, 2012-07-22 at 23:57 -0700, Shirley Ma wrote:
> Introduce a new API to choose per-cpu thread from cgroup control cpuset
> (allowed) and preferred cpuset (local numa-node).
> 
> The receiving cpus of a networking device are not under cgroup controls.
> When such a networking device uses per-cpu thread model, the cpu which
> is chose to process the packets might not be part of cgroup cpusets
> without this API. On numa system, the preferred cpusets would help to
> reduce expensive cross memory access to/from the other node.
> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ---
> 
>  include/linux/sched.h |    2 ++
>  kernel/sched/fair.c   |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 0 deletions(-)
> 
> Thanks
> Shirley
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


