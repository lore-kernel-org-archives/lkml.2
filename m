Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1DRJVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:21:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1DRJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:21:41 -0400
Date: Mon, 18 Apr 2011 05:21:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org
Subject: block workqueues
Message-ID: <20110418092141.GB32013@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

is there any reason that blk_delay_queue queues to the system workqueue and
not kblockd?
