Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0IIKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 06:33:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45193 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0IIKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 06:33:12 -0400
Date: Thu, 9 Sep 2010 12:33:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Hugepage migration (v5)
Message-ID: <20100909123306.32134d5e@basil.nowhere.org>
In-Reply-To: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Sep 2010 10:19:31 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Hi,
> 
> This is the 5th version of "hugepage migration" set.
> 
> Changes from v4 (mostly refactoring):
> - remove unnecessary might_sleep() [3/10]
> - define migrate_huge_pages() from copy of migrate_pages() [4/10]
> - soft_offline_page() branches off to hugepage path. [8/10]

I went over this patchkit again and it all looks good to me.
I plan to merge it through my hwpoison tree.

As far as I understand all earlier comments have been addressed
with this revision, correct?

Thanks for your work, this is very good.

But I would like to have some Acks from Christoph for the
page migration changes and from Mel for the hugetlb changes
outside memory-failures.c. Are the patches ok for you two? 
Can I have your Acked-by or Reviewed-by? 

Any other comments would be welcome too.

I am considering to fast track 10/10 (the page-types fix). 

I think the other bug fixes in the series are only for bugs added
earlier in the series, correct?

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
