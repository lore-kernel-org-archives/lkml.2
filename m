Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2K1Bau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:30:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2K1Bat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:30:49 -0500
Date: Tue, 27 Nov 2012 23:30:31 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fix balloon_page_movable() page->flags check
Message-ID: <20121128013031.GA2071@x61.redhat.com>
References: <20121127145708.c7173d0d.akpm@linux-foundation.org>
 <1ccb1c95a52185bcc6009761cb2829197e2737ea.1354058194.git.aquini@redhat.com>
 <20121127155201.ddfea7e1.akpm@linux-foundation.org>
 <20121128003409.GB7401@t510.redhat.com>
 <20121127171544.8bbb702a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127171544.8bbb702a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 05:15:44PM -0800, Andrew Morton wrote:
> On Tue, 27 Nov 2012 22:34:10 -0200 Rafael Aquini <aquini@redhat.com> wrote:
> 
> > Do you want me to resubmit this patch with the changes you suggested?
> 
> oh, I think I can reach that far.  How's this look?
>

It looks great to me.

Just a small nitpick, 
here __balloon_page_flags should be changed to page_flags_cleared too:
> @@ -109,18 +110,16 @@ static inline void balloon_mapping_free(
>  /*
>   * __balloon_page_flags - helper to perform balloon @page ->flags tests.
>   *

Thanks!
--Rafael
