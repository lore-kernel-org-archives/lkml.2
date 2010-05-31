Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0EaKT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:19:29 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42778 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0EaKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:19:26 -0400
Date: Mon, 31 May 2010 19:17:46 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/8] HWPOISON for hugepage (v6)
Message-ID: <20100531101746.GB5370@spritzera.linux.bs1.fc.nec.co.jp>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100531093009.GA10766@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100531093009.GA10766@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:30:09AM +0200, Andi Kleen wrote:
> On Fri, May 28, 2010 at 09:29:14AM +0900, Naoya Horiguchi wrote:
> > Hi,
> > 
> > Here is a "HWPOISON for hugepage" patchset which reflects
> > Mel's comments on hugepage rmapping code.
> > Only patch 1/8 and 2/8 are changed since the previous post.
> > 
> > Mel, could you please restart reviewing and testing?
> 
> Thanks everyone, I merged this patch series in the hwpoison
> tree now, aimed for 2.6.36. It should appear in linux-next
> shortly.

Thank you.

> Question is how to proceed now: the next steps would
> be early kill support

Does early kill for hugetlb work with this patchset, doesn't it?
Do you mean something else?

> and soft offline/migration support for
> hugetlb too. Horiguchi-san, is this something you're interested
> in working on?

Yes, it is.
I'll do it with pleasure :)

Thanks,
Naoya Horiguchi
