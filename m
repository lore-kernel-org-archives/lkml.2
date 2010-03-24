Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0CXF0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:26:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37749 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab0CXF0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:26:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Mar 2010 14:22:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, andi.kleen@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] [BUGFIX] pagemap: fix pfn calculation for hugepage
Message-Id: <20100324142250.62753e03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100324051845.GA9017@spritzerA.linux.bs1.fc.nec.co.jp>
References: <1268979996-12297-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20100319161023.d6a4ea8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319162732.58633847.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319171310.7d82f8eb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100324051845.GA9017@spritzerA.linux.bs1.fc.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 14:18:45 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Fri, Mar 19, 2010 at 05:13:10PM +0900, KAMEZAWA Hiroyuki wrote:
> ...
> > > 
> > > But, this means hugeltb_entry() is not called per hugetlb entry...isn't it ?
> > > 
> > > Why hugetlb_entry() cannot be called per hugeltb entry ? Don't we need a code
> > > for a case as pmd_size != hugetlb_size in walk_page_range() for generic fix ?
> > > 
> > 
> > How about this style ? This is an idea-level patch. not tested at all.
> > (I have no test enviroment for multiple hugepage size.)
> > 
> > feel free to reuse fragments from this patch.
> >
> 
> So the point is calling hugetlb_entry() for each huge page, right?
> 
yes.

> It looks good.
> I've rewritten my patch based on your idea and make sure it works.
> Is it ok to add your Signed-off-by?
Of course.

Thanks.
-Kame

