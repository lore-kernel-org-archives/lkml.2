Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1EDLF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:05:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1EDLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:05:17 -0400
Date: Wed, 4 May 2011 07:05:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: introduce writeback_control.inodes_cleaned
Message-ID: <20110504110500.GB4646@infradead.org>
References: <20110420080336.441157866@intel.com>
 <20110420080917.890756812@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420080917.890756812@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same here - this has nothing to do with actual page writeback and really
should stay internal to fs/fs-writeback.c

