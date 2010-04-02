Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0DBGpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:45:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab0DBGpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:45:15 -0400
Date: Fri, 2 Apr 2010 08:45:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 0/3] blkio: IO controller stats
Message-ID: <20100402064514.GW23510@kernel.dk>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01 2010, Divyesh Shah wrote:
> The following series implements some additional stats for IO controller.
> 
> These stats have helped us debug issues with earlier IO controller
> versions and should be useful now as well.
> We've been using these stats for monitoring and debugging problems after the
> fact as these stats can be collected and stored for later use.
> 
> One might argue that most of this information can be exported using blktrace
> when debugging. However, blktrace has non-trivial performance impact and
> cannot be always turned on. These stats provide a way for continuous monitoring
> without losing much performance on rotational disks. We've been able to look
> at these stats and debug issues after problems have been reported in the wild
> and understand the IO pattern of the affected workloads.
> Some of these stats are also a good data source for high-level analysis and
> capacity planning.
> 
> This patchset adds 4 stats and I will send out another patchset later for
> stats like io_merged and some stats that can be turned on only for
> debugging - idle_time (total time spent idling for this blkio_group),
> wait_time (total time spent by the blkio_group waiting before any one of its
> queues got a timeslice). I've tried to breakdown the stats and sent the most
> basic ones here.

Thanks, I think this makes sense. I've applied it for 2.6.35.

-- 
Jens Axboe

