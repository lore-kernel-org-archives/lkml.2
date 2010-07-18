Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0GRGtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 02:49:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0GRGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 02:49:13 -0400
Date: Sun, 18 Jul 2010 02:49:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 06/16] writeback: improve bdi_has_dirty_io
Message-ID: <20100718064912.GE23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-7-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-7-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you skip this one for now?  I have a patch moving the remaining
writeback related fields (wb_lock and work_list) into
struct bdi_writeback, which also means getting rid of bdi_has_dirty_io
entirely in favour of wb_has_dirty_io.

