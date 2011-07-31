Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1GaQbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:31:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54984 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1GaQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:31:29 -0400
Date: Mon, 1 Aug 2011 01:31:21 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 08/10] ilru: reduce zone->lru_lock
Message-ID: <20110731163121.GB2864@barrios-desktop>
References: <cover.1309787991.git.minchan.kim@gmail.com>
 <100bcc5d254e5e88f91356876b1d2ce463c2309e.1309787991.git.minchan.kim@gmail.com>
 <20110727131405.0b663296.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727131405.0b663296.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 01:14:05PM -0700, Andrew Morton wrote:
> On Mon,  4 Jul 2011 23:04:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > inorder_lru increases zone->lru_lock overhead(pointed out by Mel)
> > as it doesn't support pagevec.
> > This patch introduces ilru_add_pvecs and APIs.
> 
> aww geeze, this patch goes and deletes most of the code I just reviewed!
> 
> Can we fold them please?

Of course!

-- 
Kind regards,
Minchan Kim
