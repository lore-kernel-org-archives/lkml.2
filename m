Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0DEVBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:01:42 -0400
Received: from thunk.org ([69.25.196.29]:37626 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab0DEVBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:01:35 -0400
Date: Mon, 5 Apr 2010 17:01:33 -0400
From: tytso@mit.edu
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, esandeen@redhat.com
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Message-ID: <20100405210133.GG23670@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jeff Moyer <jmoyer@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
 <20100405175205.GA4681@thunk.org>
 <x49hbnpkaqw.fsf@segfault.boston.devel.redhat.com>
 <20100405194803.GC23670@thunk.org>
 <x49zl1hiqoz.fsf@segfault.boston.devel.redhat.com>
 <x49vdc5iqcz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vdc5iqcz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 04:41:48PM -0400, Jeff Moyer wrote:
> > Sorry, Ted, what I meant to say was that iozone showed differences
> > between deadline and cfq, where cfq's performance was much worse than
> > deadline's.
> 
> And to be 100% clear, with the patch, the performance differences
> between deadline and cfq were in the noise.

Right, and since most people don't actually change the I/O scheduler
from cfq, this is basically a performance improvement patch, which is
how I'm going to describe it.  :-)

						- Ted
