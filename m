Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0GBHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:52:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0GBHw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:52:57 -0400
Date: Fri, 2 Jul 2010 03:52:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, axboe@kernel.dk, hch@lst.de,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of
 q->prepare_flush_fn()
Message-ID: <20100702075248.GB21266@infradead.org>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
> We could kill q->prepare_flush_fn(). Except for ide, all the users
> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
> do like SCSI.

Yes, and I think you should go all the way to kill it instead of
keeping both APIs around.  Otherwise the patchset looks good to me.

