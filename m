Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1IADjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:39:09 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12973 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544Ab1IADjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:39:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8CACr7Xk55LIxDgWdsb2JhbABCqE8VAQEWJiWBQAEBBTocIxAIAw4KLhQlAyETwToOhkcEm2OIXQ
Date: Thu, 1 Sep 2011 13:39:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901033902.GN32358@dastard>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831052627.GA5338@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 01:26:27AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 30, 2011 at 02:51:01PM -0700, Daniel Ehrenberg wrote:
> > > Let filesystems handle this. ?I've actually prototyped it in XFS,
> > > based on some pending work from Dave but at this point it's still butt
> > > ugly.
> > 
> > Great, would you be willing to let me see the draft code?
> > 
> > Are you sure that there wouldn't be any benefit to having the code be
> > in the aio/dio levels in terms of making it easier for file
> > systems/reducing code duplication?
> 
> I'll get it polished up and send it out for RFC once Dave sends out
> the updated allocation workqueue patch.  With this he moves all
> allocator calls in XFS into a workqueue.  My direct I/O patch uses that
> fact to use that workqueue for the allocator call and let the existing
> aio retry infrastructure retry the direct I/O operation one that
> workqueue has finished.

I thought you didn't like that code, Christoph. ;)

I'll resend it soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
