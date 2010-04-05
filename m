Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0DERwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 13:52:11 -0400
Received: from thunk.org ([69.25.196.29]:44558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0DERwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 13:52:06 -0400
Date: Mon, 5 Apr 2010 13:52:05 -0400
From: tytso@mit.edu
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, esandeen@redhat.com
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Message-ID: <20100405175205.GA4681@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jeff Moyer <jmoyer@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:04:54PM -0400, Jeff Moyer wrote:
> 
> So, I'm submitting this patch for comments and testing.  I have a
> similar patch for jbd that I will submit if folks agree that this is a
> good idea.

Added to the ext4 patch queue.

What benchmark were you using to test small file writes?  This looks
good to me as well, but we might want to do some extra benchmarking
just to be sure we're not accidentally introducing a performance
regression.

						- Ted
