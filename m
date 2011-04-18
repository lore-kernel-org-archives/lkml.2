Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1DRQd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:33:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1DRQdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:33:53 -0400
Date: Mon, 18 Apr 2011 12:33:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tao Ma <tm@tao.ma>
Cc: jaxboe@fusionio.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add blk_run_queue_async
Message-ID: <20110418163348.GA593@infradead.org>
References: <20110418092647.GB3837@infradead.org>
 <4DAC59C7.1060807@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAC59C7.1060807@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:33:27PM +0800, Tao Ma wrote:
> > +void blk_run_queue_async(struct request_queue *q);
> any reason why this function isn't put together with the __blk_run_queue
> below?

It's only used internall by the block/ code, so there's no need to have
it globally available.

