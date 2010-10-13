Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0JMLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:25:57 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52786 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0JMLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:25:55 -0400
Date: Wed, 13 Oct 2010 07:25:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013112552.GB16422@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013072058.GA3121@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 06:20:58PM +1100, Nick Piggin wrote:
> Unfortunate timing that everybody is suddenly interested in the
> scalability work :)

People have been interested for a long time.  It's just that we finally
made forward progress to get parts of it shape for merging, which should
have been done long time ago.

> I might need a little more time than 2.6.37! But I'll try my best.
> I don't think the patchset has suddenly become vastly more urgent
> in the past month, so I think my approach of having it get a lot
> of testing and go in Al's vfs tree for a while is best.

It's always been quite urgent.  Both inode_lock and dcache_lock
contention have been hurting us for a while.

