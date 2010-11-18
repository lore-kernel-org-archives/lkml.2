Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0KRMxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:53:07 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab0KRMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:53:05 -0500
Date: Thu, 18 Nov 2010 12:52:50 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 17 of 66] add pmd mangling generic functions
Message-ID: <20101118125249.GN8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <6022613f956ee326d9b6.1288798072@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <6022613f956ee326d9b6.1288798072@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:27:52PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Some are needed to build but not actually used on archs not supporting
> transparent hugepages. Others like pmdp_clear_flush are used by x86 too.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
