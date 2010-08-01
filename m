Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0HAPXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 11:23:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43890 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0HAPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 11:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uiBXtbS4l2x6HppG3ofCNwkm04ZJdBOseYoHEVnjTx1+ZnrEmlibv8bQeTzjzJ5jz8
         tP6dIki+L/haT1m1pkyCj4A5YQVBbAUquoGUSksnKaeBDMMzZ+8by1JrjOP1QZQVxRry
         l3qwFaQMukMb27O/kv1vXa9ZnL5Chtu2+7BWA=
Date: Mon, 2 Aug 2010 00:23:02 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/6] writeback: pass writeback_control down to
 move_expired_inodes()
Message-ID: <20100801152302.GB8158@barrios-desktop>
References: <20100722050928.653312535@intel.com>
 <20100722061822.484666925@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722061822.484666925@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:09:29PM +0800, Wu Fengguang wrote:
> This is to prepare for moving the dirty expire policy to move_expired_inodes().
> No behavior change.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
