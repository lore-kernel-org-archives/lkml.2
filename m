Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0KJQLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:11:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0KJQLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:11:13 -0500
Date: Wed, 10 Nov 2010 17:08:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 43 of 66] don't leave orhpaned swap cache after ksm
 merging
Message-ID: <20101110160838.GK6809@random.random>
References: <patchbomb.1288798055@v2.random>
 <d5aefe85d1dab1bb7e99.1288798098@v2.random>
 <20101109120747.BC4B.A69D9226@jp.fujitsu.com>
 <20101109214036.GE6809@random.random>
 <alpine.LSU.2.00.1011092312360.6873@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1011092312360.6873@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:49:30PM -0800, Hugh Dickins wrote:
> We did ask you back then to send in a fix separate from THP, but both
> sides then forgot about it until recently.

Correct :).

> We didn't agree on what the fix should look like.  You're keen to change
> the page locking there, I didn't make a persuasive case for keeping it
> as is, yet I can see no point whatever in changing it for this swap fix.
> Could I persuade you to approve this simpler alternative?

Sure your version will work fine too. I insisted in removing the page
lock around replace_page because I didn't see the point of it and I
like strict code, but keeping it can do no harm.
