Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2HNQMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2HNQMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:12:12 -0400
Date: Tue, 14 Aug 2012 17:12:08 +0100
From: Mel Gorman <mgorman@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-commits@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Patch "mm: hugetlbfs: close race during teardown of hugetlbfs
 shared page tables" has been added to the 3.4-stable tree
Message-ID: <20120814161208.GP4177@suse.de>
References: <13448816423660@kroah.org>
 <CAP=VYLrdCqA_BEN09YQjz1RQjZfZfM_k_RjrsJwkFztyhc0SRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAP=VYLrdCqA_BEN09YQjz1RQjZfZfM_k_RjrsJwkFztyhc0SRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:37:53AM -0400, Paul Gortmaker wrote:
> On Mon, Aug 13, 2012 at 2:14 PM,  <gregkh@linuxfoundation.org> wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     mm: hugetlbfs: close race during teardown of hugetlbfs shared page tables
> >
> > to the 3.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch
> > and it can be found in the queue-3.4 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> The original was:
> 
>  include/linux/hugetlb.h |   11 +++++++++++
>  mm/hugetlb.c            |   28 ++++++++++++++++++++++++++--
>  mm/memory.c             |    2 +-
>  3 files changed, 38 insertions(+), 3 deletions(-)
> 
> while the patch below is:
> 
>   mm/hugetlb.c |   25 +++++++++++++++++++++++--
>   1 file changed, 23 insertions(+), 2 deletions(-)
> 
> It wasn't obvious to me if this was intentional, so I thought I'd
> mention it.
> 

Well spotted but the difference is due to the mainline commit needed to
work with other patches that were not backported. The backported patch
was simpler but functionally the different versions should be equivalent.

-- 
Mel Gorman
SUSE Labs
