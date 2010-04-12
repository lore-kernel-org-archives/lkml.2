Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0DMBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:21:40 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49904 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754599Ab0DMBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:21:14 -0400
Date: Mon, 12 Apr 2010 10:11:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, xfs@oss.sgi.com,
       axboe@kernel.dk
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
 please!...)
Message-ID: <20100412001158.GA2493@dastard>
References: <t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
 <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
 <20100402230905.GW3335@dastard>
 <22c901cad333$7a67db60$0400a8c0@dcccs>
 <20100404103701.GX3335@dastard>
 <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
 <20100405224522.GZ3335@dastard>
 <3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
 <20100408025822.GL11036@dastard>
 <11b701cad9c8$93212530$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11b701cad9c8$93212530$0400a8c0@dcccs>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:44:37AM +0200, Janos Haar wrote:
> Hi,
> 
> Ok, here comes the funny part:
> I have got several messages from the kernel about one of my XFS
> (sdb2) have corrupted inodes, but my xfs_repair (v. 2.8.11) says the
> FS is clean and shine.
> Should i upgrade my xfs_repair, or this is another bug? :-)

v2.8.11 is positively ancient. :/

I'd upgrade (current is 3.1.1) and re-run repair again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
