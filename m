Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab1FVUK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:10:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49351 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab1FVUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:10:27 -0400
Date: Wed, 22 Jun 2011 22:10:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dehrenberg@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] DIO: Inline the complete submission path
Message-ID: <20110622201026.GJ3263@one.firstfloor.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org> <1308770322-22565-7-git-send-email-andi@firstfloor.org> <20110622195955.GB24311@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622195955.GB24311@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 03:59:56PM -0400, Christoph Hellwig wrote:
> > -static ssize_t
> > +static inline ssize_t
> >  direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
> >  	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
> >  	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
> 
> For this one please just merge it into the caller.  There's no logical
> separation between the two anyway.

The compiler does that anyways.

Or did you mean in source? That would conflict with the coding standard.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
