Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1LTXyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:54:43 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58887 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1LTXyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:54:40 -0500
Date: Wed, 21 Dec 2011 00:54:28 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Caspar Zhang <caspar@casparzhang.com>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] [v2] mempolicy: refix mbind_range() vma issue
Message-ID: <20111220235428.GD3870@cmpxchg.org>
References: <20111212112000.GB18789@cmpxchg.org>
 <1324405032-22281-1-git-send-email-kosaki.motohiro@gmail.com>
 <20111220192850.GB3870@cmpxchg.org>
 <20111220153757.8d80af1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220153757.8d80af1e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:37:57PM -0800, Andrew Morton wrote:
> On Tue, 20 Dec 2011 20:28:50 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Minchan Kim <minchan.kim@gmail.com>
> > > CC: Caspar Zhang <caspar@casparzhang.com>
> > 
> > Looks good to me now, thanks.
> > 
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > Since this can corrupt virtual mappings and was released with 3.2, I
> > think we also want this:
> > 
> > Cc: stable@kernel.org [3.2.x]
> 
> I assume you meant 3.1.x  And into mainline for 3.2?

Yes.
