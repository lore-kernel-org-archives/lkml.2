Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1FXN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:59:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281Ab1FXN7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:59:42 -0400
Date: Fri, 24 Jun 2011 14:59:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: P?draig Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: vmscan: Do not apply pressure to slab if we are
 not applying pressure to zone
Message-ID: <20110624135937.GR9396@suse.de>
References: <1308922998-15529-1-git-send-email-mgorman@suse.de>
 <1308922998-15529-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1308922998-15529-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 02:43:16PM +0100, Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
> 

Bah, I accidentally exported a branch with a build error in this
patch. Will resend shortly.

-- 
Mel Gorman
SUSE Labs
