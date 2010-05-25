Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0EYLLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:11:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0EYLLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:11:07 -0400
Date: Tue, 25 May 2010 07:11:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       tytso@mit.edu, jens.axboe@oracle.com
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100525111106.GA6076@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274784852-30502-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:54:10PM +1000, Dave Chinner wrote:
> This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> above trace was generated) and does the revert manually leaving the subsequent

The tracepoint really should be a separate commit, probably ordered
before the ext4 revert.

