Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0DEWp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:45:56 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:54418 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589Ab0DEWpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:45:50 -0400
Date: Tue, 6 Apr 2010 08:45:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, xfs@oss.sgi.com,
       axboe@kernel.dk
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
 please!...)
Message-ID: <20100405224522.GZ3335@dastard>
References: <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
 <20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
 <02c101cacbf8$d21d1650$0400a8c0@dcccs>
 <179901cad182$5f87f620$0400a8c0@dcccs>
 <t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
 <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
 <20100402230905.GW3335@dastard>
 <22c901cad333$7a67db60$0400a8c0@dcccs>
 <20100404103701.GX3335@dastard>
 <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 08:17:27PM +0200, Janos Haar wrote:
> Dave,
> 
> Thank you for your answer.
> Like i sad before, this is a productive server with important service.
> Can you please send the fix for me as soon as it is done even for
> testing it....
> Or point me to the right direction to get it?

It's in 2.6.33 if you want to upgrade the kernel, or you if don't
want to wait for the next 2.6.32.x kernel, you can apply this series
of 19 patches yourself:

http://oss.sgi.com/archives/xfs/2010-03/msg00125.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
