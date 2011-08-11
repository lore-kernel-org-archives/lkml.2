Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1HKXpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:45:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52743
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444Ab1HKXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:45:20 -0400
Date: Thu, 11 Aug 2011 19:45:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110811234516.GA21649@infradead.org>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <20110810110056.GA31756@infradead.org>
 <20110810111547.GZ19099@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810111547.GZ19099@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 12:15:47PM +0100, Mel Gorman wrote:
> > The right fix is to simply remove that fallback, possibly in combination
> > with implementating real migration support for btrfs.
> > 
> 
> Removing the fallback entirely is overkill as proper migration support
> is not going to get 100% coverage

It seems like btrfs is indeed the only important one missing.

