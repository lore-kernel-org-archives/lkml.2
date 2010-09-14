Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0INWr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:47:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0INWr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:47:58 -0400
Date: Tue, 14 Sep 2010 18:47:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 7/7] block: autoconvert trivial BKL users to private mutex
Message-ID: <20100914224757.GA8925@infradead.org>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
 <1284494022-7346-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284494022-7346-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: virtio-blk just has the BKL because of an autoconversion from
old ->ioctl to the unlocked version.  I have a patch pending to kill it.

