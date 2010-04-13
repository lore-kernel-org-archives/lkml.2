Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0DMSGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:06:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0DMSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:06:09 -0400
Date: Tue, 13 Apr 2010 14:06:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: [PATCH 3/4] blkdev: add blkdev_issue helper functions
Message-ID: <20100413180608.GE21302@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <1271077437-7921-2-git-send-email-dmonakhov@openvz.org> <1271077437-7921-3-git-send-email-dmonakhov@openvz.org> <1271077437-7921-4-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-4-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 05:03:56PM +0400, Dmitry Monakhov wrote:
> Move blkdev_issue_discard from blk-barrier.c because it is not barrier
> related.

If you create a new file just for discard I would call it blk-discard.c.
But I can't really be bothered too much about the placement of this two
functions, so do whatever is fine with you and Jens.

