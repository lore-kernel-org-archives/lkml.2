Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab0HEGfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:35:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803Ab0HEGf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:35:28 -0400
Message-ID: <4C5A5BAE.9070301@kernel.dk>
Date: Thu, 05 Aug 2010 08:35:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20100805114725.7e46da74.sfr@canb.auug.org.au>
In-Reply-To: <20100805114725.7e46da74.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-05 03:47, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> usr/include/linux/fs.h:11: included file 'linux/blk_types.h' is not exported
> 
> Caused by commit 9d3dbbcd9a84518ff5e32ffe671d06a48cf84fd9 ("bio, fs:
> separate out bio_types.h and define READ/WRITE constants in terms of
> BIO_RW_* flags").
> 
> I used the block tree from next-20100804 for today.

Thanks Stephen, I fixed this one up now and pushed it out.

-- 
Jens Axboe

