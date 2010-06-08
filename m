Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0FHAL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:11:29 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:50266 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238Ab0FHAL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:11:28 -0400
Date: Tue, 8 Jun 2010 10:11:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V3.
Message-ID: <20100608001115.GB6965@dastard>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
 <20100604074938.GB4448@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604074938.GB4448@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 03:49:38AM -0400, Christoph Hellwig wrote:
> 
> Not sure what the rules for new tracepoints are, but in addition to the
> fixes I'd really love to see the tracepoints in 2.6.35.

Personally I think they are just as important (or even more
important) than the bug fixes because we seem to break this code
regularly because nobody can clearly see what the internals are
doing to verify their change is working correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
