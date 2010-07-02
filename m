Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0GBJI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:08:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0GBJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:08:55 -0400
Date: Fri, 2 Jul 2010 11:08:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] hugetlb: add allocate function for hugepage
 migration
Message-ID: <20100702090854.GD12221@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-4-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278049646-29769-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:47:22PM +0900, Naoya Horiguchi wrote:
> We can't use existing hugepage allocation functions to allocate hugepage
> for page migration, because page migration can happen asynchronously with
> the running processes and page migration users should call the allocation
> function with physical addresses (not virtual addresses) as arguments.

I looked through this patch and didn't see anything bad. Some more
eyes familiar with hugepages would be good though.

Since there are now so many different allocation functions some
comments on when they should be used may be useful too

-Andi
