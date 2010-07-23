Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0GWQXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:23:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0GWQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:23:13 -0400
Date: Fri, 23 Jul 2010 12:23:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 10/14] writeback: move bdi threads exiting logic to the
 forker thread
Message-ID: <20100723162311.GA29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
 <1279897554-1526-11-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279897554-1526-11-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Maybe bdi_forker_thread can be cleaned up a bit more by introducing a

enum {
	NO_ACTION,
	START_THREAD,
	KILL_THREAD,
} action;

and then do a switch based on it later?

