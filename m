Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0GCKC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 06:02:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0GCKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:02:55 -0400
Date: Sat, 3 Jul 2010 06:02:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] remove q->prepare_flush_fn hook
Message-ID: <20100703100248.GA22329@infradead.org>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 05:45:31PM +0900, FUJITA Tomonori wrote:
> This removes q->prepare_flush_fn. Except for ide and scsi, all the
> users just mark flush requests. They can use REQ_FLUSH flag
> instead.
> 
> SCSI and ide can use q->prep_rq_fn to build flush requests.
> 
> This can be applied to the block's for-2.6.36.

The whole patchset looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

