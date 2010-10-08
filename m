Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0JHNSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:18:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34665 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0JHNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:18:39 -0400
Date: Fri, 8 Oct 2010 09:16:54 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008131654.GJ4804@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008072749.GB7831@lst.de>
 <20101008075001.GT4681@dastard>
 <20101008081714.GB1728@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008081714.GB1728@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:17:14AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 06:50:01PM +1100, Dave Chinner wrote:
> > > There's no need to lock a normal 32-bit variable for readers.
> > 
> > Ok, but will need a memory barrier instead?
> 
> Isn't spin_unlock supposed to be one?  I'll need some of the locking
> experts to shime in.

Not really a locking expert, but the locking operations are supposed to
have an implicit barrier.

-chris

