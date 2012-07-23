Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2GWJiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:38:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2GWJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:37:58 -0400
Date: Mon, 23 Jul 2012 10:37:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Stable <stable@vger.kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/34] kswapd: assign new_order and new_classzone_idx
 after wakeup in sleeping
Message-ID: <20120723093754.GP9222@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-22-git-send-email-mgorman@suse.de>
 <alpine.LSU.2.00.1207221213100.1896@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207221213100.1896@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 12:25:14PM -0700, Hugh Dickins wrote:
> On Thu, 19 Jul 2012, Mel Gorman wrote:
> > From: "Alex,Shi" <alex.shi@intel.com>
> > 
> > commit d2ebd0f6b89567eb93ead4e2ca0cbe03021f344b upstream.
> 
> Thanks for assembling these, Mel: I was checking through to see if
> I was missing any, and noticed that this one has the wrong upstream
> SHA1: the one you give here is the same as in 20/34, but it should be
> 
> commit f0dfcde099453aa4c0dc42473828d15a6d492936 upstream.
> 

You're correct, thanks for catching that.

> I got quite confused by 30/34 too: interesting definition of "partial
> backport" :) I've no objection, but "substitute" might be clearer there.
> 

It's a liberal definition of the phrase "partial backport" all right.
I'll substitute "substitute" :)

-- 
Mel Gorman
SUSE Labs
