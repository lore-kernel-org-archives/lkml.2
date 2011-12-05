Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1LERGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:06:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab1LERGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:06:52 -0500
Date: Mon, 5 Dec 2011 17:06:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Question about __zone_watermark_ok: why there is a "+ 1" in
 computing free_pages?
Message-ID: <20111205170646.GC5070@suse.de>
References: <CAKXJSOHu+sQ1NeMsRvFyp2GYoB6g+50boUu=-QvbxxjcqgOAVA@mail.gmail.com>
 <20111205161443.GA20663@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111205161443.GA20663@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 05:14:43PM +0100, Michal Hocko wrote:
> From 38a1cf351b111e8791d2db538c8b0b912f5df8b8 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 5 Dec 2011 17:04:23 +0100
> Subject: [PATCH] mm: fix off-by-two in __zone_watermark_ok
> 
> 88f5acf8 [mm: page allocator: adjust the per-cpu counter threshold when
> memory is low] changed the form how free_pages is calculated but it
> forgot that we used to do free_pages - ((1 << order) - 1) so we ended up
> with off-by-two when calculating free_pages.
> 
> Spotted-by: Wang Sheng-Hui <shhuiw@gmail.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
