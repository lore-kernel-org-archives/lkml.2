Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0FYSQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:16:42 -0400
Received: from [18.85.46.34] ([18.85.46.34]:39395 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab0FYSQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:16:41 -0400
Date: Fri, 25 Jun 2010 14:16:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100625181638.GA15227@infradead.org>
References: <20100624131455.GA10441@laptop>
 <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca>
 <20100625040156.GQ10441@laptop>
 <1A529206-98C4-4A88-A2CA-18522D4D631D@dilger.ca>
 <AANLkTin__C1EOuTFJJ4UqAFsO5x_IOKLX11boRl7B194@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin__C1EOuTFJJ4UqAFsO5x_IOKLX11boRl7B194@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 10:52:05AM -0700, Ulrich Drepper wrote:
> there are not that many flags which are portable and available on all
> the platforms.  Look at /usr/include/bits/statvfs.h for what has to be
> supported and the values to use.  If the values the kernel will use
> differ I'd have to (unnecessarily) convert the values.  If some values
> are missing/not supported I still would have to use /proc/mounts and
> nothing is gained.

I don't quite get what ST_WRITE is supposed to mean.  All but that one
can be supported trivially.
