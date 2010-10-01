Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0JAC7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:59:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0JAC7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:59:20 -0400
Date: Thu, 30 Sep 2010 22:59:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc1] unmount livelock due to racing with bdi-flusher
 threads
Message-ID: <20101001025916.GA12345@infradead.org>
References: <20100821084126.GE31488@dastard>
 <20100913024128.GC411@dastard>
 <20100930210250.GE3573@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930210250.GE3573@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:02:51PM +0200, Jan Kara wrote:
> I think the best resolution of this problem would be to change the work
> that is submitted via bdi_start_writeback() (i.e., the work without
> superblock = work which needs to do locking) to "target based scheme" like
> Christoph wanted already some time ago. I actually have a patch to do this
> for background writeback so I will just modify it to apply to a wider range
> of writeback as well. Or Christoph, do you already have some patches in
> this direction?

I've not started any work on it yet.

