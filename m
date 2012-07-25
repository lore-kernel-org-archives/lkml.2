Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab2GYWs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:48:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2GYWs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:48:56 -0400
Date: Wed, 25 Jul 2012 23:48:52 +0100
From: Mel Gorman <mgorman@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/34] Memory management performance backports for
 -stable V2
Message-ID: <20120725224852.GF9222@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <20120725223057.GA4253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120725223057.GA4253@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 03:30:57PM -0700, Greg KH wrote:
> > <SNIP>
> > All of the patches will apply to 3.0-stable but the ordering of the
> > patches is such that applying them to 3.2-stable and 3.4-stable should
> > be straight-forward.
> 
> I can't find any of these that should have gone to 3.4-stable, given
> that they all were included in 3.4 already, right?
> 

Yes, you're right.

At the time I wrote the changelog I had patches belonging to 3.5 included. I
later decided to drop them until after 3.5 was out. It was potentially
weird to have a 3.0-stable kernel with patches that were not in a released
3.x.0 kernel. Besides, they were very low priority. I forgot to update
the changelog to match.

> I've queued up the whole lot for the 3.0-stable tree, thanks so much for
> providing them.
> 

Thanks for reviewing them in detail and getting the flaws corrected.
I expect it'll be a bit more smooth if/when I do something like this again.

-- 
Mel Gorman
SUSE Labs
