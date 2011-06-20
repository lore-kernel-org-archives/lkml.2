Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1FTThM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:37:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1FTThL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:37:11 -0400
Date: Mon, 20 Jun 2011 21:37:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: print information when THP is disabled
 automatically
Message-ID: <20110620193702.GH20843@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <1308587683-2555-3-git-send-email-amwang@redhat.com>
 <20110620170106.GC9396@suse.de>
 <4DFF82E2.1010409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF82E2.1010409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong,

On Tue, Jun 21, 2011 at 01:26:58AM +0800, Cong Wang wrote:
> But, there are many printk messages in the same file start with "hugepage:".
> :-) I can send a patch to replace all of them with "THP" if you want...

Those are in failure paths practically impossible to trigger unless
the memory layout is misconfigured and the kernel won't succeed
booting so I guess I didn't care much what I wrote in those 3 sorry.
Replacing those with THP surely sounds valid cleanup to avoid
confusion if you add a "THP:" prefix elsewhere.

Thanks,
Andrea
