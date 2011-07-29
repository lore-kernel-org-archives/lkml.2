Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1G2IXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:23:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49254 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1G2IXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:23:23 -0400
Date: Fri, 29 Jul 2011 17:23:13 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 00/10] Prevent LRU churning
Message-ID: <20110729082313.GA1843@barrios-desktop>
References: <cover.1309787991.git.minchan.kim@gmail.com>
 <20110727131650.ad30a331.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727131650.ad30a331.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 01:16:50PM -0700, Andrew Morton wrote:
> On Mon,  4 Jul 2011 23:04:33 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Test result is following as.
> > 
> > 1) Elapased time 10GB file decompressed.
> > Old			inorder			inorder + pagevec flush[10/10]
> > 01:47:50.88		01:43:16.16		01:40:27.18
> > 
> > 2) failure of inorder lru
> > For test, it isolated 375756 pages. Only 45875 pages(12%) are put backed to
> > out-of-order(ie, head of LRU) Others, 329963 pages(88%) are put backed to in-order
> > (ie, position of old page in LRU).
> 
> I'm getting more and more worried about how complex MM is becoming and
> this patchset doesn't take us in a helpful direction :(

Hmm. I think it's not too complicated stuff. :(
But I understand your concern enoughly.

> 
> But it's hard to argue with numbers like that.  Please respin patches 6-10?

Of course, but it would be rather late due to my business and other interesting features.
I will try to get a new data point in next version.

Thanks, Andrew.

> 
> 

-- 
Kind regards,
Minchan Kim
