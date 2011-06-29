Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1F2PJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:09:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:22128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1F2PJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="21923319"
Message-Id: <20110629145245.835998321@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] write bandwidth estimation and writeback fixes v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are mainly seperated out from the original IO-less writeback
patchset. They are general useful as standalone improvements.

The v1 patches were posted in two threads:

	http://lkml.org/lkml/2011/6/12/69
	http://lkml.org/lkml/2011/6/19/97

In addition to the changes posted in the above threads, I also extended the
global_dirty_state trace with more fields, and improved some more changelog.

	[PATCH 1/9] writeback: make writeback_control.nr_to_write straight
	[PATCH 2/9] writeback: account per-bdi accumulated written pages
	[PATCH 3/9] writeback: bdi write bandwidth estimation
	[PATCH 4/9] writeback: show bdi write bandwidth in debugfs
	[PATCH 5/9] writeback: consolidate variable names in balance_dirty_pages()
	[PATCH 6/9] writeback: introduce smoothed global dirty limit
	[PATCH 7/9] writeback: introduce max-pause and pass-good dirty limits
	[PATCH 8/9] writeback: scale IO chunk size up to half device bandwidth
	[PATCH 9/9] writeback: trace global_dirty_state

They are git pullable from

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback

Thanks,
Fengguang


