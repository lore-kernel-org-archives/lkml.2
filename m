Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0DDKhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:37:36 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:38879 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752734Ab0DDKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:37:31 -0400
Date: Sun, 4 Apr 2010 20:37:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, xfs@oss.sgi.com,
       axboe@kernel.dk
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
 please!...)
Message-ID: <20100404103701.GX3335@dastard>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
 <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
 <20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
 <02c101cacbf8$d21d1650$0400a8c0@dcccs>
 <179901cad182$5f87f620$0400a8c0@dcccs>
 <t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
 <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
 <20100402230905.GW3335@dastard>
 <22c901cad333$7a67db60$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22c901cad333$7a67db60$0400a8c0@dcccs>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 03:42:10PM +0200, Janos Haar wrote:
> Hello,
> 
> The actual version of kernel is 2.6.32.10.
> There is any significant fixes for me in the last (.11) or in the
> next (33.x)?

The fixes for this bug are queued up already for the next
2.6.32.x release.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
