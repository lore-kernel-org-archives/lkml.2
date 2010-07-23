Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0GWQ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:28:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab0GWQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:28:01 -0400
Date: Fri, 23 Jul 2010 12:28:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 12/14] writeback: optimize periodic bdi thread wakeups
Message-ID: <20100723162800.GB29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
 <1279897554-1526-13-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279897554-1526-13-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't reviewed this in detail, but what ensures the timer is
synchronously removed when the forker goes away?  I don't see a
del_timer_sync call anywhere.  For now it might be easier to just
skip this patch and leave it for later.

