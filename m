Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab1IAEVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 00:21:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44336
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1IAEVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 00:21:01 -0400
Date: Thu, 1 Sep 2011 00:20:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901042057.GA11540@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
 <20110901033902.GN32358@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901033902.GN32358@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 01:39:02PM +1000, Dave Chinner wrote:
> > I'll get it polished up and send it out for RFC once Dave sends out
> > the updated allocation workqueue patch.  With this he moves all
> > allocator calls in XFS into a workqueue.  My direct I/O patch uses that
> > fact to use that workqueue for the allocator call and let the existing
> > aio retry infrastructure retry the direct I/O operation one that
> > workqueue has finished.
> 
> I thought you didn't like that code, Christoph. ;)

I still don't like it, but in for this case it actually was helpful.
You'll always have to see the positive side of things.

