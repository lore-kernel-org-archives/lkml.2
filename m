Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2J2BmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 21:42:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47985 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2J2BmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:42:22 -0400
X-AuditID: 9c930197-b7c4aae000004160-04-508ddefb3b67
Date: Mon, 29 Oct 2012 10:48:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/5] mm, highmem: use PKMAP_NR() to calculate an index of
 pkmap
Message-ID: <20121029014805.GF15767@bbox>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
 <1351451576-2611-2-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351451576-2611-2-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:12:52AM +0900, Joonsoo Kim wrote:
> To calculate an index of pkmap, using PKMAP_NR() is more understandable
> and maintainable, So change it.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
