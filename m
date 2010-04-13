Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0DMSIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:08:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0DMSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:08:37 -0400
Date: Tue, 13 Apr 2010 14:08:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: [PATCH 1/4] blkdev: pass gfp_mask and flags to
	blkdev_issue_flush
Message-ID: <20100413180836.GA1483@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 05:03:54PM +0400, Dmitry Monakhov wrote:
> In some places caller don't want to wait a request to complete.
> Flags make blkdev_issue_flush() more flexible. This patch just
> convert existing callers to new interface without chaining
> existing allocation/wait behavior.

Looks okay to me, but as mention in the other review I would introduce
the comment flags first and then add the flags to blkdev_issue_flush,
not the other way around.

