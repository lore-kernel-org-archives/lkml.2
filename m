Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1FFO0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:26:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51675 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1FFO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bc4k2LQvm3RIPyce24ujdYb6NWGx+JZm/9QyDveaod9HeGaIleUqmojFwYIdHOniJJ
         Lltmb83hCK3CrmgCVOeMzLaXzZGhHrbBmORUfGLY8kBECo+ZxnRUtA6ICoLuiT2EFRqs
         auYdoHbv1+cMUFkfCIqE/H+jbRI9A2JHclL0g=
Date: Mon, 6 Jun 2011 23:26:23 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110606142623.GF1686@barrios-laptop>
References: <20110531141402.GK19505@random.random>
 <20110531143734.GB13418@barrios-laptop>
 <20110531143830.GC13418@barrios-laptop>
 <20110602182302.GA2802@random.random>
 <20110602202156.GA23486@barrios-laptop>
 <20110602214041.GF2802@random.random>
 <BANLkTim1WjdHWOQp7bMg5pFFKp1SSFoLKw@mail.gmail.com>
 <20110602223201.GH2802@random.random>
 <BANLkTikA+ugFNS95Zs_o6QqG2u4r2g93=Q@mail.gmail.com>
 <20110606101557.GA5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606101557.GA5247@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:15:57AM +0100, Mel Gorman wrote:
> On Fri, Jun 03, 2011 at 08:01:44AM +0900, Minchan Kim wrote:
> > On Fri, Jun 3, 2011 at 7:32 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > > On Fri, Jun 03, 2011 at 07:23:48AM +0900, Minchan Kim wrote:

<snip>

> > >> AFAIK, it's final destination to go as compaction will not break lru
> > >> ordering if my patch(inorder-putback) is merged.
> > >
> > > Agreed. I like your patchset, sorry for not having reviewed it in
> > > detail yet but there were other issues popping up in the last few
> > > days.
> > 
> > No problem. it's urgent than mine. :)
> > 
> 
> I'm going to take the opportunity to apologise for not reviewing that
> series yet. I've been kept too busy with other bugs to set side the
> few hours I need to review the series. I'm hoping to get to it this
> week if everything goes well.

I am refactoring the code about migration.
Maybe, I will resend it on tomorrow.
I hope you guys reviews that. :)

Thanks, Mel.

> 
> -- 
> Mel Gorman
> SUSE Labs

-- 
Kind regards
Minchan Kim
