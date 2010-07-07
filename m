Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0GGWyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:54:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37818 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0GGWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:54:13 -0400
Date: Thu, 8 Jul 2010 00:17:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] hugetlb: add missing unlock in avoidcopy path in
 hugetlb_cow()
Message-ID: <20100707221717.GD3900@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278049646-29769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:47:20PM +0900, Naoya Horiguchi wrote:
> This patch fixes possible deadlock in hugepage lock_page()
> by adding missing unlock_page().
> 
> libhugetlbfs test will hit this bug when the next patch in this
> patchset ("hugetlb, HWPOISON: move PG_HWPoison bit check") is applied.

I merged this patch into the hwpoison tree now.

For the other patches in the series waiting until the open issues
are fixed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
