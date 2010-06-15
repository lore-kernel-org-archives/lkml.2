Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0FONhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:37:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0FONhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:37:45 -0400
Date: Tue, 15 Jun 2010 09:37:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100615133727.GA27980@infradead.org>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-13-git-send-email-mel@csn.ul.ie>
 <4C16A567.4080000@redhat.com>
 <20100615114510.GE26788@csn.ul.ie>
 <4C17815A.8080402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17815A.8080402@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 09:34:18AM -0400, Rik van Riel wrote:
> If direct reclaim can overflow the stack, so can direct
> memcg reclaim.  That means this patch does not solve the
> stack overflow, while admitting that we do need the
> ability to get specific pages flushed to disk from the
> pageout code.

Can you explain what the hell memcg reclaim is and why it needs
to reclaim from random contexts?
It seems everything that has a cg in it's name that I stumbled over
lately seems to be some ugly wart..

