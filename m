Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1JIIEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 04:04:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1JIIEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 04:04:43 -0400
Date: Sun, 9 Oct 2011 17:04:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        akpm@linux-foundation.org, Josh Boyer <jwboyer@redhat.com>,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Abort reclaim/compaction if compaction can
 proceed
Message-ID: <20111009080434.GD23003@barrios-desktop>
References: <1318000643-27996-1-git-send-email-mgorman@suse.de>
 <1318000643-27996-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318000643-27996-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:17:23PM +0100, Mel Gorman wrote:
> If compaction can proceed, shrink_zones() stops doing any work but
> the callers still shrink_slab(), raises the priority and potentially
> sleeps.  This patch aborts direct reclaim/compaction entirely if
> compaction can proceed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim
