Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0FDHs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:48:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0FDHsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:48:54 -0400
Date: Fri, 4 Jun 2010 03:48:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100604074852.GA4448@infradead.org>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com> <1275609328-12514-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275609328-12514-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.  Can please get this in ASAP, including -stable?

> This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> above trace was generated) and does the revert manually leaving the subsequent
> bug fixes intact. ext4 is not affected by this as a previous commit in the
> series stops ext4 from using the generic function.

It doesn't anymore now that you've split it out..

