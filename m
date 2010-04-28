Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0D1FeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 01:34:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34501 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0D1FeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 01:34:13 -0400
Date: Wed, 28 Apr 2010 07:34:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20100428053410.GO27497@kernel.dk>
References: <20100428135258.35e3efdb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428135258.35e3efdb.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28 2010, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> include/linux/coda_psdev.h:4: included file 'linux/backing-dev.h' is not exported
> 
> Caused by commit 5163d90076729413cb882d3dd5c3d3cfb5b9f035 ("coda: add bdi
> backing to mount session").
> 
> I have used the version of the block tree from next-20100427 for today.

Thanks Stephen, I'll fix it up.

-- 
Jens Axboe

