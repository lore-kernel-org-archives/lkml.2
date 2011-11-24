Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1KXODf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1KXODf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:03:35 -0500
Date: Thu, 24 Nov 2011 15:03:27 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: compaction: push isolate search base of compact
 control one pfn ahead
Message-ID: <20111124140327.GP8397@redhat.com>
References: <CAJd=RBCJwyo3dQAYmE3oXBBDMDa5GkePfQ_Sct_YUt5=_1-ovw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCJwyo3dQAYmE3oXBBDMDa5GkePfQ_Sct_YUt5=_1-ovw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:38:14PM +0800, Hillf Danton wrote:
> After isolated the current pfn will no longer be scanned and isolated if the
> next round is necessary, so push the isolate_migratepages search base of the
> given compact_control one step ahead.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Actually I did this change in my tree already while playing with
compaction last few days so I didn't actually need to review.
