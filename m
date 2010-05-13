Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab0EMPrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:47:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0EMPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:47:12 -0400
Date: Thu, 13 May 2010 11:47:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
	slashes
Message-ID: <20100513154710.GA19228@infradead.org>
References: <1273747977-4579-1-git-send-email-jack@suse.cz> <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org> <20100513154135.GB21251@quack.suse.cz> <20100513084335.7267bcf5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513084335.7267bcf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:43:35AM -0400, Andrew Morton wrote:
> Yes, it's a bit tricky (for me, at least) to work out "which kernel version did
> that patch go into" via git.

git-describe <revid>

