Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1LUGHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:07:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46879 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1LUGHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:07:48 -0500
Date: Wed, 21 Dec 2011 15:07:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
Message-ID: <20111221060739.GD28505@barrios-laptop.redhat.com>
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
 <1324445481.20505.7.camel@joe2Laptop>
 <20111221054531.GB28505@barrios-laptop.redhat.com>
 <1324447099.21340.6.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324447099.21340.6.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 09:58:19PM -0800, Joe Perches wrote:
> On Wed, 2011-12-21 at 14:45 +0900, Minchan Kim wrote:
> > On Tue, Dec 20, 2011 at 09:31:21PM -0800, Joe Perches wrote:
> > > On Wed, 2011-12-21 at 14:17 +0900, Minchan Kim wrote:
> > > > We don't like function body which include #ifdef.
> []
> > > I don't like this change.
> > > I think it's perfectly good style to use:
> > I feel it's no problem as it is because it's very short function now
> > but it's not style we prefer. 
> 
> Who is this "we" you refer to?
> 
> There's nothing suggesting your patch as a preferred style
> in Documentation/CodingStyle.

Yes. It doesn't have. 
But I have thought we have done until now.
I think we can see them easily.

#> grep -nRH 'static inline void' ./ | grep {} | wc -l
936

If we consider line which don't include brace in one line, it would be many.

> 
> cheers, Joe
> 

-- 
Kind regards,
Minchan Kim
