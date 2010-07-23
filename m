Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886Ab0GWQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:28:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab0GWQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:28:12 -0400
Date: Fri, 23 Jul 2010 12:28:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 13/14] writeback: remove unnecessary init_timer call
Message-ID: <20100723162811.GC29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
 <1279897554-1526-14-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279897554-1526-14-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 06:05:53PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> The 'setup_timer()' function also calls 'init_timer()', so the extra
> 'init_timer()' call is not needed. Indeed, 'setup_timer()' is basically
> 'init_timer()' plus callback function and data pointers initialization.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

