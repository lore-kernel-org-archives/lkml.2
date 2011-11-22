Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab1KVRFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:05:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52241 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1KVRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:05:34 -0500
Date: Wed, 23 Nov 2011 02:05:27 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] mm: check if we isolated a compound page during
 lumpy scan
Message-ID: <20111122170527.GC15253@barrios-laptop.redhat.com>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321900608-27687-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 06:36:44PM +0000, Mel Gorman wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Properly take into account if we isolated a compound page during the
> lumpy scan in reclaim and skip over the tail pages when encounted.
> This corrects the values given to the tracepoint for number of lumpy
> pages isolated and will avoid breaking the loop early if compound
> pages smaller than the requested allocation size are requested.
> 
> [mgorman@suse.de: Updated changelog]
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I would like to see removing lumpy part in vmscan.c.
It is complicated day by day. :(

Having said that, it looks good to me now.

-- 
Kind regards,
Minchan Kim
