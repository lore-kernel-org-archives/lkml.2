Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1LSJiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:38:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44999 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1LSJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:38:03 -0500
Message-ID: <4EEF05F5.3050600@kernel.dk>
Date: Mon, 19 Dec 2011 10:37:57 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
In-Reply-To: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-19 04:19, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "ioc_cgroup_changed" [block/blk-cgroup.ko] undefined!
> 
> Caused by commit dc86900e0a8f ("block, cfq: move ioc ioprio/cgroup
> changed handling to cic").
> 
> I have used the block tree from next-20111215 again today.

Missing export, I've fixed it up and pushed out the change. Lets hope
tomorrows tree is more succesful :-)

-- 
Jens Axboe

