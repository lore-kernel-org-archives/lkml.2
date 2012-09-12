Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161Ab2ILP4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:56:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759703Ab2ILP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:56:05 -0400
Date: Wed, 12 Sep 2012 16:55:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/3] Minor changes to common hugetlb code for ARM
Message-ID: <20120912155555.GF32234@mudshark.cambridge.arm.com>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
 <20120912152759.GR21579@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912152759.GR21579@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:27:59PM +0100, Michal Hocko wrote:
> On Tue 11-09-12 17:47:13, Will Deacon wrote:
> > A few changes are required to common hugetlb code before the ARM support
> > can be merged. I posted the main one previously, which has been picked up
> > by akpm:
> > 
> >   http://marc.info/?l=linux-mm&m=134573987631394&w=2
> > 
> > The remaining three patches (included here) are all fairly minor but do
> > affect other architectures.
> 
> I am quite confused. Why THP changes are required for hugetlb code for
> ARM?

Sorry, I was being too vague. We add ARM support for THP in the same patch
series as hugetlb, so I was loosely referring to that lot.

> Besides that I would suggest adding Andrea to the CC (added now the
> whole series can be found here http://lkml.org/lkml/2012/9/11/322) list
> for all THP changes.

Thanks for that, I'll add Andrew to future submissions.

Will
