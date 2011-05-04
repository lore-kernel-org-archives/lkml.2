Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1EDJ2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:28:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:6973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1EDJ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="637712465"
Message-Id: <20110504091707.910929441@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 17:17:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/6] writeback fixes and trace events
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are one more collection of simple writeback patches.

two already reviewed fixes

	[PATCH 1/6] writeback: add bdi_dirty_limit() kernel-doc
	[PATCH 2/6] writeback: skip balance_dirty_pages() for in-memory fs

a straightforward write size optimization

	[PATCH 3/6] writeback: make nr_to_write a per-file limit

two new trace events

	[PATCH 4/6] writeback: trace event writeback_single_inode
	[PATCH 5/6] writeback: trace event writeback_queue_io

an RFC wbc_writeback_* trace format change
(please drop it if cannot get ACKs from others)

	[PATCH 6/6] writeback: convert to relative older_than_this in trace events

Thanks,
Fengguang

