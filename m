Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1FSP1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:27:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:22966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab1FSP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:27:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="15432277"
Message-Id: <20110619150108.691351746@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 19 Jun 2011 23:01:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] more writeback patches for 3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are mainly seperated out from the original IO-less writeback
patchset. They are general useful as standalone improvements. This
series is based on the write bandwidth patches posted at

	https://lkml.org/lkml/2011/6/12/69

They'll appear in this git branch after a while, and be posted in one
single series for the next version.

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback

cleanups
	[PATCH 1/7] writeback: consolidate variable names in balance_dirty_pages()
	[PATCH 2/7] writeback: add parameters to __bdi_update_bandwidth()

dirty limits
	[PATCH 3/7] writeback: introduce smoothed global dirty limit
	[PATCH 4/7] writeback: introduce max-pause and pass-good dirty limits

write chunk size
	[PATCH 5/7] writeback: make writeback_control.nr_to_write straight
	[PATCH 6/7] writeback: scale IO chunk size up to half device bandwidth

dirty exceeded state
	[PATCH 7/7] writeback: timestamp based bdi dirty_exceeded state

Thanks,
Fengguang

