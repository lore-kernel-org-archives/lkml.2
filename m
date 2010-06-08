Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0FHIDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:03:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab0FHIDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:03:33 -0400
Date: Tue, 8 Jun 2010 04:03:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V3.
Message-ID: <20100608080324.GA3119@infradead.org>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
 <20100604074938.GB4448@infradead.org>
 <20100608001115.GB6965@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608001115.GB6965@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:11:15AM +1000, Dave Chinner wrote:
> On Fri, Jun 04, 2010 at 03:49:38AM -0400, Christoph Hellwig wrote:
> > 
> > Not sure what the rules for new tracepoints are, but in addition to the
> > fixes I'd really love to see the tracepoints in 2.6.35.
> 
> Personally I think they are just as important (or even more
> important) than the bug fixes because we seem to break this code
> regularly because nobody can clearly see what the internals are
> doing to verify their change is working correctly.

Given that Linus is pretty strict about only taking regression fixes
I'd rather get the regression fix in and miss out on the tracing until
the next merge window then missing out on everything.
