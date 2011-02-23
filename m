Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1BWWqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:46:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab1BWWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:46:00 -0500
Date: Wed, 23 Feb 2011 14:44:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: optimize replace_page_cache_page
Message-Id: <20110223144445.86d0ca2b.akpm@linux-foundation.org>
In-Reply-To: <20110219234121.GA2546@barrios-desktop>
References: <1297355626-5152-1-git-send-email-minchan.kim@gmail.com>
	<20110219234121.GA2546@barrios-desktop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 08:41:21 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Resend.

Reignore.

> he patch is based on mmotm-2011-02-04 + 
> mm-add-replace_page_cache_page-function-add-freepage-hook.patch.
> 
> On Fri, Feb 11, 2011 at 01:33:46AM +0900, Minchan Kim wrote:
> > This patch optmizes replace_page_cache_page.
> > 
> > 1) remove radix_tree_preload
> > 2) single radix_tree_lookup_slot and replace radix tree slot
> > 3) page accounting optimization if both pages are in same zone.
> > 
> > Cc: Miklos Szeredi <mszeredi@suse.cz>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/filemap.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++---------
> >  1 files changed, 51 insertions(+), 10 deletions(-)
> > 
> > Hi Miklos,
> > This patch is totally not tested.
> > Could you test this patch?

^^^ Because of this.

Is it tested yet?
