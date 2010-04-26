Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0DZR0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:26:53 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58991 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0DZR0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:26:52 -0400
Date: Mon, 26 Apr 2010 19:26:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com
Subject: Re: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v2
Message-ID: <20100426172651.GT27497@kernel.dk>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <20100426150144.GB2937@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426150144.GB2937@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26 2010, Christoph Hellwig wrote:
> Jens, are you planning on picking up a version of this?

Yes, I was waiting for a repost to address your review concerns.

> 
> On Mon, Apr 12, 2010 at 05:03:53PM +0400, Dmitry Monakhov wrote:
> > - Convert all blkdev_issue_xxx function to common set of flags
> > - move common functions to block/blk-lib.c
> > - Add generic zeroout helper
> > 
> > changes from V1
> > Christoph is about to change discard memory payload allocation logic
> > so discard cleanups are no longer necessary.
> ---end quoted text---

-- 
Jens Axboe

