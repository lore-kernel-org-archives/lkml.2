Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1AKDon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:44:43 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52882 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab1AKDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:44:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABtgK015LcNW/2dsb2JhbACkNnS7RYVMBJA0
Date: Tue, 11 Jan 2011 14:44:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110111034434.GB5271@amd>
References: <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104083132.GA4485@amd>
 <20110104092541.GC2760@infradead.org>
 <20110104095231.GB4812@amd>
 <20110106204911.GB2872@infradead.org>
 <20110107044836.GB4552@amd>
 <20110107072510.GB32308@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107072510.GB32308@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:25:10AM -0500, Christoph Hellwig wrote:
> On Fri, Jan 07, 2011 at 03:48:36PM +1100, Nick Piggin wrote:
> > OK, I don't exactly see why a sync_inode with appropriate flag could
> > not solve that problem. I'll take a bit more look through nfs and
> > xfs. Thanks...
> 
> We could also overload all inode operations into a single ioctl like
> method, but that doesn't make it a good design.

I've been a bit busy lately and haven't had time to continue this
discussion. Thanks for your input so far, and I'll get back to it soon.

I will try to get out a set of changes for current merge window that
fix the bulk of the problems without going into areas you disagree
with, and then we can have a smaller set of changes we to agree on for
next merge window. I will come back and reply to your points when I
get a bit more time.


