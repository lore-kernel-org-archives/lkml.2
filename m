Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2DDGtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:49:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62752 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2DDGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:49:05 -0400
Date: Tue, 3 Apr 2012 23:49:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Wang Sheng-Hui <shhuiw@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb.c: cleanup to use long vars instead of int
 in region_count
In-Reply-To: <alpine.DEB.2.00.1203071331150.15255@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204032348470.3865@chino.kir.corp.google.com>
References: <4EE6F24B.7050204@gmail.com> <alpine.DEB.2.00.1203071331150.15255@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, David Rientjes wrote:

> On Tue, 13 Dec 2011, Wang Sheng-Hui wrote:
> 
> > args f & t and fields from & to of struct file_region are defined
> > as long. Use long instead of int to type the temp vars.
> > 
> > Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> > ---
> >  mm/hugetlb.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index dae27ba..e666287 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -195,8 +195,8 @@ static long region_count(struct list_head *head, long f, long t)
> >  
> >  	/* Locate each segment we overlap with, and count that overlap. */
> >  	list_for_each_entry(rg, head, link) {
> > -		int seg_from;
> > -		int seg_to;
> > +		long seg_from;
> > +		long seg_to;
> >  
> >  		if (rg->to <= f)
> >  			continue;
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Andrew, it looks like this never made it to linux-next.
> 

Still not in linux-next as of today.
