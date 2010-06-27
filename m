Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0F0Jwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 05:52:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0F0Jwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 05:52:33 -0400
Date: Sun, 27 Jun 2010 05:52:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3] block: introduce REQ_FLUSH flag
Message-ID: <20100627095223.GA6447@infradead.org>
References: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1277305652-2306-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277305652-2306-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/include/linux/bio.h
> @@ -152,6 +152,7 @@ enum rq_flag_bits {
>  	__REQ_SYNC,		/* request is sync (sync write or read) */
>  	__REQ_META,		/* metadata io request */
>  	__REQ_DISCARD,		/* request to discard sectors */
> +	__REQ_FLUSH,		/* request for cache flush */

As we only used this in the request it should go into the struct request
only section at the end of the flags.

