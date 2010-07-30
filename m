Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0G3Jkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:40:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab0G3Jkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:40:40 -0400
Date: Fri, 30 Jul 2010 05:40:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: move del_gendisk() from fs/partitions/check.c to
 block/genhd.c
Message-ID: <20100730094038.GA9570@infradead.org>
References: <1280482741.1851.3.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280482741.1851.3.camel@yio.site>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 11:39:01AM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: block: move del_gendisk() from fs/partitions/check.c to block/genhd.c
> 
> Disk code belongs into genhd, not into the partition scanner code.

Sounds fine for del_gendisk, but read_dev_sector which isn't mentioned
here really is for partitioning.

