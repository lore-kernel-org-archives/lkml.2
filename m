Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0EYLN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:13:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0EYLN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:13:27 -0400
Date: Tue, 25 May 2010 07:13:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       tytso@mit.edu, jens.axboe@oracle.com
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Message-ID: <20100525111326.GA8931@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274784852-30502-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define CREATE_TRACE_POINTS
> +#include <trace/events/writeback.h>

It might be worth to add a comment why this is in an unusal place.

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
