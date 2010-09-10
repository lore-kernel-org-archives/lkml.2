Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0IJOma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab0IJOm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:42:28 -0400
Message-ID: <4C8A43BD.6020301@redhat.com>
Date: Fri, 10 Sep 2010 10:42:05 -0400
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
Subject: Re: [PATCH 4/4] hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_anon_rmap()
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1284092586-1179-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1284092586-1179-5-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 12:23 AM, Naoya Horiguchi wrote:
> Confirming page lock is held in hugetlb_add_anon_rmap() may be useful
> to detect possible future problems.
>
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
