Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0IJOks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0IJOkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:40:47 -0400
Message-ID: <4C8A4353.5050802@redhat.com>
Date: Fri, 10 Sep 2010 10:40:19 -0400
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
Subject: Re: [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 12:23 AM, Naoya Horiguchi wrote:
> This patch applies Andrea's fix given by the following patch into hugepage
> rmapping code:
>
>    commit 288468c334e98aacbb7e2fb8bde6bc1adcd55e05
>    Author: Andrea Arcangeli<aarcange@redhat.com>
>    Date:   Mon Aug 9 17:19:09 2010 -0700
>
> This patch uses anon_vma->root and avoids unnecessary overwriting when
> anon_vma is already set up.
>
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
