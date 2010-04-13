Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0DMSFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:05:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab0DMSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:05:10 -0400
Date: Tue, 13 Apr 2010 14:05:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: [PATCH 2/4] blkdev: generalize flags for blkdev_issue_fn
	functions
Message-ID: <20100413180508.GD21302@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <1271077437-7921-2-git-send-email-dmonakhov@openvz.org> <1271077437-7921-3-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-3-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 05:03:55PM +0400, Dmitry Monakhov wrote:
> The patch just convert all blkdev_issue_xxx function to common
> flags. Wait/allocation semantics not changed.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good in general.  But I would re-order this to be patch 1 so you
can avoid introducing flags for blkdev_issue_flush just to replace them
in the next one.

