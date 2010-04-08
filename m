Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0DHMqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:46:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53136 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0DHMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:46:31 -0400
Date: Thu, 8 Apr 2010 14:46:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Divyesh Shah <dpshah@google.com>, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Subject: Re: [PATCH][v3.1] blkio: Add io controller stats like
Message-ID: <20100408124629.GN10103@kernel.dk>
References: <20100406232533.25602.46349.stgit@austin.mtv.corp.google.com> <4BBD3DB9.8090006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBD3DB9.8090006@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Gui Jianfeng wrote:
> Divyesh Shah wrote:
> > - io_service_time (the total time between request dispatch and completion for
> >   all IOs in the cgroup)
> > - io_wait_time (the total time spent waiting by all IOs in this cgroup in the IO
> >   scheduler queues before getting serviced)
> > - io_serviced (number of IOs serviced from this blkio_group)
> > - io_service_bytes (Number of bytes served for this cgroup)
> > 
> > These stats are accumulated per operation type helping us to distinguish between
> > read and write, and sync and async IO. This patch does not increment any of
> > these stats.
> > 
> > Changelog from v3:
> > o renamed blkiocg_reset_write to blkiocg_reset_stats
> > o more clarification in the documentation on io_service_time and io_wait_time.
> > 
> > Signed-off-by: Divyesh Shah<dpshah@google.com>
> 
> Hi Divyesh,
> 
> Jens has already applied previous patchset to for-2.6.35 branch, so v3 patchset
> and this patch have conflicts with for-2.6.35 branch. I think it's better to make
> new patch on top of for-2.6.35.

Thanks, was just about to ask. Please make an updated patch against what
I already have, so I don't have to revert/rebase to make this work.

-- 
Jens Axboe

