Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0IJOlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:41:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0IJOlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:41:00 -0400
Message-ID: <4C8A4365.2040305@redhat.com>
Date: Fri, 10 Sep 2010 10:40:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] hugetlb, rmap: use hugepage_add_new_anon_rmap() in
 hugetlb_cow()
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1284092586-1179-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1284092586-1179-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 12:23 AM, Naoya Horiguchi wrote:
> Obviously, setting anon_vma for COWed hugepage should be done
> by hugepage_add_new_anon_rmap() to scan vmas faster.
> This patch fixes it.
>
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> ---
>   mm/hugetlb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
