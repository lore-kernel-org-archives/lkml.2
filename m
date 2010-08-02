Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0HBMrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:47:48 -0400
Received: from verein.lst.de ([213.95.11.210]:43678 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab0HBMrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:47:46 -0400
Date: Mon, 2 Aug 2010 14:47:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] writeback: remove wb in get_next_work_item
Message-ID: <20100802124739.GA22345@lst.de>
References: <1280673774-8072-1-git-send-email-minchan.kim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280673774-8072-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 11:42:54PM +0900, Minchan Kim wrote:
> 83ba7b07 cleans up the writeback.
> So we don't use wb any more in get_next_work_item.
> Let's remove unnecessary argument.

If we can get it in this merge windows it's fine with me.  If not I have
patches pending that use only the bdi_writeback inside fs/fs-writeback.c
and completely get rid of the backing-dev.

