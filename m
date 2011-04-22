Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1DVDDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 23:03:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:43699 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1DVDD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 23:03:29 -0400
Date: Thu, 21 Apr 2011 20:03:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Minchan Kim <minchan.kim@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1104212000420.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011 at 11:58, Minchan Kim wrote:
> But I wonder why VM can't reclaim the pages. As I see the log, there
> are lots of slab pages(710M) in DMA zone while LRU pages are very
> small. SLAB pages are things VM has a trouble to reclaim. I am not
> sure 710M of SLAB is reasonable size. Don't you have experience same
> problem in old kernel?

No, I forgot to add 2.6.38 (and before) did not show that behaviour.

> If you see the problem first in 2.6.39-rc4, maybe it would be a
> regression(ex, might be slab memory leak)

I would think so. I'll try to bisect, but with one compilation taking 
~20min on this box, this might take a while.

> Could you get the information about slabinfo(ex, cat /proc/slabinfo)
> right before OOM happens.

When it happens again, I'll try to get this.

Thanks for replying,
Christian.
-- 
BOFH excuse #73:

Daemons did it
