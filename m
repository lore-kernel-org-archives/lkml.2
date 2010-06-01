Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0FAIct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:32:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0FAIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:32:47 -0400
Date: Tue, 1 Jun 2010 04:32:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-ID: <20100601083244.GA2496@infradead.org>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au> <20100601081823.GA29991@infradead.org> <20100601082246.GA3564@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601082246.GA3564@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Talking about the block tree: can we please get the two writeback
reverts in?  -rc1 is copletly unsuable under heavy I/O loads as it
stands.
