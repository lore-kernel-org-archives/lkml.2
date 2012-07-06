Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2GFPt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2GFPtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:49:24 -0400
Message-ID: <4FF708EB.10600@redhat.com>
Date: Fri, 06 Jul 2012 11:48:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, suresh.b.siddha@intel.com, danms@us.ibm.com,
        tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] mm/mpol: Re-implement check_*_range() using
 walk_page_range()
References: <tip-o0ih1vq2js8eswn0nmr6w49r@git.kernel.org>
In-Reply-To: <tip-o0ih1vq2js8eswn0nmr6w49r@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 06:21 AM, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  8c41549ed1b3adefe17fa78a2cab81ed7060f0e5
> Gitweb:     http://git.kernel.org/tip/8c41549ed1b3adefe17fa78a2cab81ed7060f0e5
> Author:     Peter Zijlstra<a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 30 Jan 2012 17:23:26 +0100
> Committer:  Ingo Molnar<mingo@kernel.org>
> CommitDate: Thu, 17 May 2012 14:06:12 +0200
>
> mm/mpol: Re-implement check_*_range() using walk_page_range()
>
> We have this very nice generic page-table walker, use it to save a few
> lines and make it easier to later reuse various bits of this existing
> machinery.
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Fixes-by: Dan Smith<danms@us.ibm.com>

> Signed-off-by: Ingo Molnar<mingo@kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
