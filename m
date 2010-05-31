Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0EaJaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:30:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0EaJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:30:17 -0400
Date: Mon, 31 May 2010 11:30:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/8] HWPOISON for hugepage (v6)
Message-ID: <20100531093009.GA10766@basil.fritz.box>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:29:14AM +0900, Naoya Horiguchi wrote:
> Hi,
> 
> Here is a "HWPOISON for hugepage" patchset which reflects
> Mel's comments on hugepage rmapping code.
> Only patch 1/8 and 2/8 are changed since the previous post.
> 
> Mel, could you please restart reviewing and testing?

Thanks everyone, I merged this patch series in the hwpoison
tree now, aimed for 2.6.36. It should appear in linux-next
shortly.

Question is how to proceed now: the next steps would
be early kill support and soft offline/migration support for
hugetlb too. Horiguchi-san, is this something you're interested
in working on?

-Andi

