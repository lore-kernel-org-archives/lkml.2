Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0KJCo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:44:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:45736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0KJCoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="855968055"
Message-Id: <20101110023500.404859581@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 10 Nov 2010 10:35:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] writeback livelock fixes v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are the writeback livelock fixes (patch 3, 4) from Jan Kara.

changes from v1:

- collect the various changelog and comment changes from email discussions


 [PATCH 1/5] writeback: integrated background writeback work
 [PATCH 2/5] writeback: trace wakeup event for background writeback
 [PATCH 3/5] writeback: stop background/kupdate works from livelocking other works
 [PATCH 4/5] writeback: avoid livelocking WB_SYNC_ALL writeback
 [PATCH 5/5] writeback: check skipped pages on WB_SYNC_ALL

 fs/fs-writeback.c                |  105 +++++++++++++++++++++++------
 include/trace/events/writeback.h |    1 
 2 files changed, 87 insertions(+), 19 deletions(-)

Thanks,
Fengguang

