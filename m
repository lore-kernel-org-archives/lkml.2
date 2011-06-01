Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1FASTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:19:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43542 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FASTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:19:45 -0400
Date: Wed, 1 Jun 2011 19:19:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
	instead of failing
Message-ID: <20110601181918.GO3660@n2100.arm.linux.org.uk>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 10:23:15AM -0700, David Rientjes wrote:
> On Wed, 1 Jun 2011, Dmitry Eremin-Solenikov wrote:
> 
> > I've hit this with IrDA driver on PXA. Also I've seen the report regarding
> > other ARM platform (ep-something). Thus I've included Russell in the cc.
> > 
> 
> So you want to continue to allow the page allocator to return pages from 
> anywhere, even when GFP_DMA is specified, just as though it was lowmem?

No.  What *everyone* is asking for is to allow the situation which has
persisted thus far to continue for ONE MORE RELEASE but with a WARNING
so that these problems can be found without causing REGRESSIONS.

That is NOT an unreasonable request, but it seems that its far too much
to ask of you.
