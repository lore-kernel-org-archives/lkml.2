Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0GKCoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:44:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0GKCox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:44:53 -0400
Date: Sat, 10 Jul 2010 22:44:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] writeback cleanups and trivial fixes
Message-ID: <20100711024404.GA6805@infradead.org>
References: <20100711020656.340075560@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100711020656.340075560@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 10:06:56AM +0800, Wu Fengguang wrote:
> Andrew,
> 
> Here are some writeback cleanups to avoid unnecessary calculation overheads,
> and relative simple bug fixes.
> 
> The patch applies to latest linux-next tree. The mmotm tree will need rebase
> to include commit 32422c79 (writeback: Add tracing to balance_dirty_pages)
> in order to avoid merge conflicts.

Maybe it's a better idea to get them in through Jens' tree?  At least he
has handled all my flusher thread patches, and I have another big series
in preparation which might cause some interesting conflicts if not
merged through the same tree.

