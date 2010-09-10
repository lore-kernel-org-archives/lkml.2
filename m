Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IJOkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0IJOkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:40:24 -0400
Date: Fri, 10 Sep 2010 16:39:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] hugetlb, rmap: use hugepage_add_new_anon_rmap() in
 hugetlb_cow()
Message-ID: <20100910143946.GW8925@random.random>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1284092586-1179-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284092586-1179-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:23:04PM +0900, Naoya Horiguchi wrote:
> Obviously, setting anon_vma for COWed hugepage should be done
> by hugepage_add_new_anon_rmap() to scan vmas faster.
> This patch fixes it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/hugetlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
