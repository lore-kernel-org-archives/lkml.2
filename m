Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1LULoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:44:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1LULny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:43:54 -0500
Date: Wed, 21 Dec 2011 20:43:37 +0900
From: Minchan Kim <minchan@kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup: mm/migrate.c: cleanup comment for function
 migration_entry_wait
Message-ID: <20111221114337.GB12472@barrios-laptop.redhat.com>
References: <4EF1BE69.5090300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF1BE69.5090300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 07:09:29PM +0800, Wang Sheng-Hui wrote:
> migration_entry_wait can also be called from hugetlb_fault now.
> Cleanup the comment.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Alternative is to add hugetlbe_fault in comment but I think it's not useful
because We can find caller easily with cscope or just grep. 
My feeling is that the comment isn't helpful.
So I am okay to remove this comment.

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
