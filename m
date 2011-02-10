Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1BJNe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:34:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39452 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab1BJNeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:34:25 -0500
Date: Thu, 10 Feb 2011 13:34:00 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 1/5] pagewalk: only split huge pages when necessary
Message-ID: <20110210133359.GI17873@csn.ul.ie>
References: <20110209195406.B9F23C9F@kernel> <20110209195407.2CE28EA0@kernel> <20110210111125.GC17873@csn.ul.ie> <20110210131928.GV3347@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110210131928.GV3347@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 02:19:28PM +0100, Andrea Arcangeli wrote:
> On Thu, Feb 10, 2011 at 11:11:25AM +0000, Mel Gorman wrote:
> > Before we goto this retry, there is at a cond_resched(). Just to confirm,
> > we are depending on mmap_sem to prevent khugepaged promoting this back to
> > a hugepage, right? I don't see a problem with that but I want to be
> > sure.
> 
> Correct, and we depend on that everywhere as wait_split_huge_page has
> to run without holding spinlocks.
> 

In that case;

Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks.

-- 
Mel Gorman
SUSE Labs
