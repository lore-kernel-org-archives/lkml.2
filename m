Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486Ab2FVHNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:13:52 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61621 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761458Ab2FVHNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:13:50 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-57-4fe41b2c3f94
Message-ID: <4FE41B3F.6090106@kernel.org>
Date: Fri, 22 Jun 2012 16:14:07 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: mmotm 2012-06-21-16-20 uploaded
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 06/22/2012 08:21 AM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> It contains the following patches against 3.5-rc3:
> (patches marked "*" will be included in linux-next)
> 
>   origin.patch
> * selinux-fix-something.patch

< snip>

> * mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
> * mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch


Above two patch should be dropped. It has a bug.
Ref: https://lkml.org/lkml/2012/6/13/529

I sent bug fix patch.
1. https://lkml.org/lkml/2012/6/13/568

And then, clean up patch.
2. https://lkml.org/lkml/2012/6/13/570

Bartlomiej rebased his patch on above two patches.

3. https://lkml.org/lkml/2012/6/14/361

I hope I am not too late.

-- 
Kind regards,
Minchan Kim
