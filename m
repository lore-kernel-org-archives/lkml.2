Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0DZCpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 22:45:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:49534 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0DZCp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 22:45:29 -0400
Date: Sun, 25 Apr 2010 22:45:27 -0400
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100426024527.GD13043@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
 <20100425033315.GC667@thunk.org>
 <20100426014908.GD11437@dastard>
 <20100426024302.GC13043@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426024302.GC13043@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 10:43:02PM -0400, tytso@MIT.EDU wrote:
> Have you tested with multiple files that are subject to writeout at
> the same time?  After all, if your I/O allocator does a great job of
> keeping the files contiguous in chunks larger tham 4MB, then if you
> have two or more files that need to be written out, the page allocator
> will round robin between the two files in 4MB chunks, and that might
> not be considered an ideal I/O pattern.

Argh.  Sorry for not proof reading better before hitting the send
key....

s/tham/than/
s/page allocator/writeback code/

						- Ted
