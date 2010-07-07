Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0GGGqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:46:50 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37244 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0GGGqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:46:47 -0400
Date: Wed, 7 Jul 2010 15:44:44 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
Message-ID: <20100707064444.GB21962@spritzera.linux.bs1.fc.nec.co.jp>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-7-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100705095927.GC8510@basil.fritz.box>
 <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1007061100530.4938@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007061100530.4938@router.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 11:02:04AM -0500, Christoph Lameter wrote:
> On Tue, 6 Jul 2010, Naoya Horiguchi wrote:
> 
> > Hmm, this chunk need to be fixed because I had too specific assumption.
> > The list passed to migrate_pages() has only one page or one hugepage in
> > page migration kicked by soft offline, but it's not the case in general case.
> > Since hugepage is not linked to LRU list, we had better simply skip
> > putback_lru_pages().
> 
> Maybe write a migrate_huge_page() function instead? The functionality is
> materially different since we are not juggling things with the lru.

OK. I'll try to devide functions for hugepage in the next turn.

Thanks,
Naoya Horiguchi
