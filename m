Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0FXBjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 21:39:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:61333 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0FXBjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 21:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,470,1272870000"; 
   d="scan'208";a="292390810"
Date: Thu, 24 Jun 2010 09:39:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: perf regression: failed to stat syscalls events
Message-ID: <20100624013915.GA16965@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I noticed that

        # perf stat -e syscalls:sys_enter_mmap true

refuse to work on 2.6.35-rc1. The last working kernel is 2.6.34.

Any suggestions before me jumping into debug?

Thanks,
Fengguang
