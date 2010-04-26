Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DZPBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:01:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DZPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:01:46 -0400
Date: Mon, 26 Apr 2010 11:01:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org,
       martin.petersen@oracle.com
Subject: Re: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v2
Message-ID: <20100426150144.GB2937@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, are you planning on picking up a version of this?

On Mon, Apr 12, 2010 at 05:03:53PM +0400, Dmitry Monakhov wrote:
> - Convert all blkdev_issue_xxx function to common set of flags
> - move common functions to block/blk-lib.c
> - Add generic zeroout helper
> 
> changes from V1
> Christoph is about to change discard memory payload allocation logic
> so discard cleanups are no longer necessary.
---end quoted text---
