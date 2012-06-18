Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2FRQae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:30:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:25980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab2FRQac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113384931"
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 3/6] Fix the x86-64 page colouring code to take pgoff into account and use that code as the basis for a generic page colouring code.
References: <1340029878-7966-1-git-send-email-riel@redhat.com>
	<1340029878-7966-4-git-send-email-riel@redhat.com>
Date: Mon, 18 Jun 2012 09:30:28 -0700
In-Reply-To: <1340029878-7966-4-git-send-email-riel@redhat.com> (Rik van
	Riel's message of "Mon, 18 Jun 2012 10:31:15 -0400")
Message-ID: <m2k3z48twb.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> writes:

> From: Rik van Riel <riel@surriel.com>
>
> Teach the generic arch_get_unmapped_area(_topdown) code to call the
> page colouring code.

What tree is that against? I cannot find x86 page colouring code in next
or mainline.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
