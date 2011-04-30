Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab1D3Dbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:31:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:52679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab1D3Dbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:31:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,292,1301900400"; 
   d="scan'208";a="686252680"
Message-Id: <20110430032243.355805181@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:22:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Tim Chen <tim.c.chen@intel.com>
cc: Li Shaohua <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 0/3] reduce readahead overheads on tmpfs mmap page faults v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I would like to update the changelogs for patches 2 and 3.
There are no changes to the code. Sorry for the inconvenience.

The original changelog is not accurate: it's solely the ra->mmap_miss updates
that caused cache line bouncing on tmpfs. ra->prev_pos won't be updated at all
on tmpfs.

Thanks,
Fengguang

