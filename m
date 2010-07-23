Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0GWLRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:17:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0GWLRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:17:50 -0400
Date: Fri, 23 Jul 2010 07:17:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Frank Mayhar <fmayhar@google.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: VFS scalability git tree
Message-ID: <20100723111746.GA5169@infradead.org>
References: <20100722190100.GA22269@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722190100.GA22269@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I might sound like a broken record, but if you want to make forward
progress with this split it into smaller series.

What would be useful for example would be one series each to split
the global inode_lock and dcache_lock, without introducing all the
fancy new locking primitives, per-bucket locks and lru schemes for
a start.

