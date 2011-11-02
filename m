Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab1KBQgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:36:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:42917 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171Ab1KBQgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:36:13 -0400
Date: Wed, 2 Nov 2011 17:35:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH 1/2] vmscan: promote shared file mapped pages
Message-ID: <20111102163527.GK19965@cmpxchg.org>
References: <20110808110658.31053.55013.stgit@localhost6>
 <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
 <4E3FD403.6000400@parallels.com>
 <20111102163056.GG19965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102163056.GG19965@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:30:56PM +0100, Johannes Weiner wrote:
> Tipping the balance for inactive list rotation has been there from the
> beginning, but I don't quite understand why.  It probably was not a
> problem as the conditions for inactive cycling applied to both file
> and anon equally, but with used-once detection for file and deferred
> file writeback from direct reclaim, we tend to cycle more file pages
> on the inactive list than anonymous ones.  Those rotated pages should
> be a signal to favor file reclaim, though.

[...] should NOT be a signal [...]

obviously.  Sorry.
