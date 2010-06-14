Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0FNPKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:10:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0FNPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:10:15 -0400
Date: Mon, 14 Jun 2010 11:10:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/12] Avoid overflowing of stack during page reclaim V2
Message-ID: <20100614151011.GA24948@infradead.org>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:17:41PM +0100, Mel Gorman wrote:
> This is a merging of two series - the first of which reduces stack usage
> in page reclaim and the second which writes contiguous pages during reclaim
> and avoids writeback in direct reclaimers.

This stuff looks good to me from the filesystem POV.

You might want to throw in a follow on patch to remove the PF_MEMALLOC
checks from the various ->writepage methods.

