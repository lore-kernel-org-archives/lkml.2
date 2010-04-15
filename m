Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0DOG4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:56:19 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48877 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0DOG4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:56:17 -0400
Date: Thu, 15 Apr 2010 08:56:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: sfr@canb.auug.org.au, guijianfeng@cn.fujitsu.com, vgoyal@redhat.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkio: Fix linux-next build failure after merge of
	block tree
Message-ID: <20100415065615.GQ27497@kernel.dk>
References: <20100415053543.15190.98919.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415053543.15190.98919.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14 2010, Divyesh Shah wrote:
> After merging the block tree, 20100414's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "get_gendisk" [block/blk-cgroup.ko] undefined!
> ERROR: "sched_clock" [block/blk-cgroup.ko] undefined!
> 
> This happens because the two symbols aren't exported and hence not available
> when blk-cgroup code is built as a module. I've tried to stay consistent with
> the use of EXPORT_SYMBOL or EXPORT_SYMBOL_GPL with the other symbols in the
> respective files.

Thanks, applied. I changed the subject to say 'fix for modular
blk-cgroup build', as that is a lot more descriptive than saying you
fixed linux-next build. It's more informative to note the actual
problem, not how it was discovered.

-- 
Jens Axboe

