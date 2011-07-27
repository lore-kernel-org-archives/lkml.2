Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1G0Hhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:37:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1G0Hho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:37:44 -0400
Date: Wed, 27 Jul 2011 08:37:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
Message-ID: <20110727073737.GG3010@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <CAEwNFnA_OGUYfCQrLCMt9NuU0O0ftWWBB4_Si8NypKyaeuRg2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEwNFnA_OGUYfCQrLCMt9NuU0O0ftWWBB4_Si8NypKyaeuRg2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 01:32:17PM +0900, Minchan Kim wrote:
> >
> > http://www.csn.ul.ie/~mel/postings/reclaim-20110721
> >
> > Unfortunately, the volume of data is excessive but here is a partial
> > summary of what was interesting for XFS.
> 
> Could you clarify the notation?
> 1P :  1 Processor?
> 512M: system memory size?
> 2X , 4X, 16X: the size of files created during test
> 

1P   == 1 Processor
512M == 512M RAM (mem=512M)
2X   == 2 x NUM_CPU fsmark threads

-- 
Mel Gorman
SUSE Labs
