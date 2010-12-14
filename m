Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab0LNRjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759787Ab0LNRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:39:50 -0500
Date: Tue, 14 Dec 2010 18:38:21 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 38 of 66] memcontrol: try charging huge pages from stock
Message-ID: <20101214173821.GI5638@random.random>
References: <patchbomb.1288798055@v2.random>
 <9d26d3daf23632b20a7b.1288798093@v2.random>
 <20101119101427.45d78929.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119101427.45d78929.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:14:27AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 03 Nov 2010 16:28:13 +0100
> Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > The stock unit is just bytes, there is no reason to only take normal
> > pages from it.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> nonsense. The stock size is CHARGE_SIZE=32*PAGE_SIZE at maximum.
> When we make this to be larger than HUGEPAGE size, 2M per cpu at least.
> This means memcg's resource "usage" accounting will have 128MB inaccuracy.
> 
> Nack.

Removed, thanks!
