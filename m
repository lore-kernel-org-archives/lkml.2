Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2FWRxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 13:53:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52528 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab2FWRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 13:53:50 -0400
Date: Sat, 23 Jun 2012 19:50:07 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm v2 10/11] mm: remove ARM arch_get_unmapped_area
 functions
Message-ID: <20120623175007.GQ27816@cmpxchg.org>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
 <1340315835-28571-11-git-send-email-riel@surriel.com>
 <20120622222756.GF30087@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622222756.GF30087@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:27:56PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 21, 2012 at 05:57:14PM -0400, Rik van Riel wrote:
> > Remove the ARM special variants of arch_get_unmapped_area since the
> > generic functions should now be able to handle everything.
> > 
> > ARM only needs page colouring if cache_is_vipt_aliasing; leave
> > shm_align_mask at PAGE_SIZE-1 unless we need colouring.
> > 
> > Untested because I have no ARM hardware.
> 
> And I'll need other bits of the patch set to be able to test this for you...

I also prefer getting 10 mails to make sense of that one change in a
series over getting that one without context.  Subjects are usually
obvious enough to quickly find out which stuff was meant for you.
