Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2J2CD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:03:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63585 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2J2CD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:03:26 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-5c-508de3ec843c
Date: Mon, 29 Oct 2012 11:09:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm, highmem: get virtual address of the page using
 PKMAP_ADDR()
Message-ID: <20121029020910.GJ15767@bbox>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
 <1351451576-2611-6-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351451576-2611-6-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:12:56AM +0900, Joonsoo Kim wrote:
> In flush_all_zero_pkmaps(), we have an index of the pkmap associated the page.
> Using this index, we can simply get virtual address of the page.
> So change it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
