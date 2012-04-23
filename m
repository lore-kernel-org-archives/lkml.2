Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2DWSKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:10:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45965 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2DWSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:10:07 -0400
Date: Mon, 23 Apr 2012 11:09:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
In-Reply-To: <20120423124124.GB3255@suse.de>
Message-ID: <alpine.LSU.2.00.1204231106450.23248@eggly.anvils>
References: <20120416141423.GD2359@suse.de> <alpine.LSU.2.00.1204161332120.1675@eggly.anvils> <20120417122202.GF2359@suse.de> <alpine.LSU.2.00.1204172023390.1609@eggly.anvils> <20120418152831.GK2359@suse.de> <alpine.LSU.2.00.1204181005500.1811@eggly.anvils>
 <20120423124124.GB3255@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Mel Gorman wrote:
> On Wed, Apr 18, 2012 at 10:09:24AM -0700, Hugh Dickins wrote:
> > > Acked-by: Mel Gorman <mgorman@suse.de>
> > > 
> > > I've sent a kernel based on this patch to the s390 folk that originally
> > > reported the bug. Hopefully they'll test and get back to me in a few
> > > days.
> > 
> > Thanks - I'll leave it at that for the moment, expecting to hear back.
> > 
> 
> Tests completed successfully confirming that this was certainly a
> PageSwapCache issue. Will you resend the patch to Andrew for merging or
> will I?
> 
> Thanks Hugh.

Great, thanks Mel: as it's a one-liner, I'll send it straight to Linus now.

Hugh
