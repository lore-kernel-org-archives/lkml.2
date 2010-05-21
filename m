Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0EUPGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:06:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0EUPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:06:40 -0400
Date: Fri, 21 May 2010 11:06:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 1/4] writeback: initial tracing support
Message-ID: <20100521150640.GB4598@infradead.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com> <1271731314-5893-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271731314-5893-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:41:51PM +1000, Dave Chinner wrote:
> From: From: Jens Axboe <jens.axboe@oracle.com>
> 
> Trace queue/sched/exec parts of the writeback loop.

If you move the CREATE_TRACE_POINTS into fs-writeback.c and include
<trace/events/writeback.h> after the sturcture defintions there's no
need to move them to a header.

