Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1LNMUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:20:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab1LNMUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:20:45 -0500
Date: Wed, 14 Dec 2011 12:20:41 +0000
From: Mel Gorman <mgorman@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickens <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] mm: Fix kswapd livelock on single core, no preempt kernel
Message-ID: <20111214122041.GF3487@suse.de>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
 <1323829490.22361.395.camel@sli10-conroe>
 <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 08:36:43PM -0800, Mike Waychison wrote:
> FYI, this was seen with a 2.6.39-based kernel with no-numa, no-memcg
> and swap-enabled.
> 

If this is 2.6.39, can you try applying the commit
[f06590bd: mm: vmscan: correctly check if reclaimer should schedule during shrink_slab]

There have been a few fixes around kswapd hogging the CPU since 2.6.39.

-- 
Mel Gorman
SUSE Labs
