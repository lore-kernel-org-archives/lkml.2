Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab2IJBXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:23:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:27183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab2IJBXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:23:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220058177"
Date: Mon, 10 Sep 2012 09:23:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [signal] WARNING: at kernel/lockdep.c:2623
 trace_hardirqs_off_caller()
Message-ID: <20120910012342.GA28439@localhost>
References: <20120910004753.GB27699@localhost>
 <20120910010706.GA28067@localhost>
 <20120910011332.GN13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910011332.GN13973@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 02:13:32AM +0100, Al Viro wrote:
> On Mon, Sep 10, 2012 at 09:07:07AM +0800, Fengguang Wu wrote:
> > Not sure if it's an unrelated warning, but anyway.
> > 
> > commit: c2865bb326476f031ce7121e876c656cdc12c894 [13/18] x86, um/x86: switch to generic sys_execve and kernel_execve
> 
> [commit in experimental-kernel_thread, not one in execve2/for-next/master]
> 
> Again, experimental-kernel_thread is build-only for now.  Is there any

OK.

> regular way to tell your script that it should be either skipped or
> only build-tested?

The build for the entire branch will be auto skipped if any of its
commits has this line in the changelog:

Dont-Auto-Build

Perhaps we can do a similar

Dont-Auto-Boot

to skip the boot tests.

Or I can simply blacklist any branches matching *experimental* and
skip both build/boot tests for them.

Thanks,
Fengguang
