Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2DWMlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:41:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab2DWMl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:41:28 -0400
Date: Mon, 23 Apr 2012 13:41:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
Message-ID: <20120423124124.GB3255@suse.de>
References: <20120416141423.GD2359@suse.de>
 <alpine.LSU.2.00.1204161332120.1675@eggly.anvils>
 <20120417122202.GF2359@suse.de>
 <alpine.LSU.2.00.1204172023390.1609@eggly.anvils>
 <20120418152831.GK2359@suse.de>
 <alpine.LSU.2.00.1204181005500.1811@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204181005500.1811@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:09:24AM -0700, Hugh Dickins wrote:
> > Acked-by: Mel Gorman <mgorman@suse.de>
> > 
> > I've sent a kernel based on this patch to the s390 folk that originally
> > reported the bug. Hopefully they'll test and get back to me in a few
> > days.
> 
> Thanks - I'll leave it at that for the moment, expecting to hear back.
> 

Tests completed successfully confirming that this was certainly a
PageSwapCache issue. Will you resend the patch to Andrew for merging or
will I?

Thanks Hugh.

-- 
Mel Gorman
SUSE Labs
