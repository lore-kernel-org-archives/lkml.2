Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab0D3R10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:27:26 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56651 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab0D3RZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:25:30 -0400
Date: Thu, 29 Apr 2010 09:28:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: linux-next: build warning after merge of the block tree
Message-ID: <20100429072853.GD27497@kernel.dk>
References: <20100429161442.7a0a4285.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429161442.7a0a4285.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29 2010, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the block tree, today's linux-next build (powerpc
> ppc44x_defconfig) produced this warning:
> 
> block/blk-lib.c: In function 'blkdev_issue_zeroout':
> block/blk-lib.c:190: warning: comparison of distinct pointer types lacks a cast
> 
> Introduced by commit 3f14d792f9a8fede64ce918dbb517f934497a4f8 ("blkdev:
> add blkdev_issue_zeroout helper function").

I fixed that warning up.

-- 
Jens Axboe

