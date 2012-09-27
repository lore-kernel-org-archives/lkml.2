Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab2I0Hhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:37:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:36281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab2I0Hhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:37:53 -0400
Message-ID: <5064022C.4080202@kernel.dk>
Date: Thu, 27 Sep 2012 09:37:16 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20120927132700.7e6ef4b714fb4a8251e68775@canb.auug.org.au>
In-Reply-To: <20120927132700.7e6ef4b714fb4a8251e68775@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 05:27 AM, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86
> 64_allmodconfig) failed like this:
> 
> usr/include/linux/fs.h:13: included file 'linux/percpu-rwsem.h' is not exported
> 
> Caused by commit 62ac665ff9fc ("blockdev: turn a rw semaphore into a
> percpu rw semaphore").
> 
> I have used the block tree from next-20120926 for today.  This will also
> affect the device-mapper tree which is based on the block tree (of which I
> will also use the next-20120926 version).

Bah, sorry about that. I have fixed it up now.

-- 
Jens Axboe

