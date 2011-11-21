Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1KUNPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:15:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:34820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1KUNPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:15:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77539447"
Message-Id: <20111121130342.211953629@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 21:03:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] dirty throttling bits for 3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to push these 5 dirty throttling improvements to linux-next,
targeting for inclusion in Linux 3.3.

It's a comfortably small series for review ;) And there are no changes since
the last v12 post. (I went through them once again but find nothing to change.)

 [PATCH 1/5] writeback: balanced_rate cannot exceed write bandwidth
 [PATCH 2/5] writeback: charge leaked page dirties to active tasks
 [PATCH 3/5] writeback: fix dirtied pages accounting on sub-page writes
 [PATCH 4/5] writeback: fix dirtied pages accounting on redirty
 [PATCH 5/5] writeback: dirty ratelimit - think time compensation

 include/linux/sched.h            |    1 
 include/linux/writeback.h        |    4 +
 include/trace/events/writeback.h |   14 ++++--
 kernel/exit.c                    |    2 
 kernel/fork.c                    |    1 
 mm/page-writeback.c              |   64 ++++++++++++++++++++++++++---
 6 files changed, 77 insertions(+), 9 deletions(-)

Thanks,
Fengguang

