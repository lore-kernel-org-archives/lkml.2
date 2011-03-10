Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1CJHPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:15:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56784 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1CJHPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:15:45 -0500
Message-ID: <4D787A9F.80207@kernel.dk>
Date: Thu, 10 Mar 2011 08:15:43 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
References: <20110310140843.15fe4e6e.sfr@canb.auug.org.au>
In-Reply-To: <20110310140843.15fe4e6e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 04:08, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/target/target_core_iblock.c: In function 'iblock_do_task':
> drivers/target/target_core_iblock.c:425: error: 'struct request_queue' has no member named 'unplug_fn'
> drivers/target/target_core_iblock.c:426: error: 'struct request_queue' has no member named 'unplug_fn'

Ah darn, recent merge. I'll fix this up.

-- 
Jens Axboe

