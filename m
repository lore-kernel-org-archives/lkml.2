Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0FXBo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 21:44:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:48479 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0FXBoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 21:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="579319490"
Date: Thu, 24 Jun 2010 09:44:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: perf regression: failed to stat syscalls events
Message-ID: <20100624014422.GA17476@localhost>
References: <20100624013915.GA16965@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624013915.GA16965@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 09:39:15AM +0800, Wu Fengguang wrote:
> Greetings,
> 
> I noticed that
> 
>         # perf stat -e syscalls:sys_enter_mmap true
> 
> refuse to work on 2.6.35-rc1. The last working kernel is 2.6.34.

Other events like lock:* or block:* or whatever continue to work.
So this is a problem specific to syscalls:*.

Thanks,
Fengguang
