Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1HGO1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 10:27:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62083 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1HGO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 10:27:41 -0400
Date: Sun, 7 Aug 2011 23:27:29 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] readahead: add comments on PG_readahead
Message-ID: <20110807142729.GA2055@barrios-desktop>
References: <20110805035040.GB11532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805035040.GB11532@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 11:50:40AM +0800, Wu Fengguang wrote:
> Add comments to clarify the easily misunderstood PG_readahead timing.
> 
> PG_readahead is a trigger to say, when you get this far, it's time to
> think about kicking off the _next_ readahead.            -- Hugh
> 
> CC: Hugh Dickins <hughd@google.com>
> CC: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I expect it would be very helpful.

-- 
Kind regards,
Minchan Kim
