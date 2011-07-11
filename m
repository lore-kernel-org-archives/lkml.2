Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GKKFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:05:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45746
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab1GKKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:05:20 -0400
Date: Mon, 11 Jul 2011 06:05:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/14] vfs: increase shrinker batch size
Message-ID: <20110711100517.GC19354@infradead.org>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
 <1310098486-6453-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310098486-6453-14-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:14:45PM +1000, Dave Chinner wrote:
> To allow for a large increase in batch size, add a conditional
> reschedule to prune_icache_sb() so that we don't hold the LRU spin
> lock for too long. This mirrors the behaviour of the
> __shrink_dcache_sb(), and allows us to increase the batch size
> without needing to worry about problems caused by long lock hold
> times.

That doesn't reflect what the patch actually does.

