Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1LAWOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:14:24 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41969 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab1LAWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:14:23 -0500
X-Sasl-enc: LXThS3CzUag6i9fzkjOo5LEaiK7wKdz4VC1B+TzHyNS/ 1322777662
Date: Thu, 1 Dec 2011 14:13:37 -0800
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David McCullough <davidm@snapgear.com>,
        D Jeff Dionne <jeff@uClinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] mm: export vmalloc_sync_all symbol to GPL modules
Message-ID: <20111201221337.GB3365@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20111201215700.GA16782@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201215700.GA16782@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:57:00PM -0500, Christoph Hellwig wrote:
> On Thu, Dec 01, 2011 at 04:41:13PM -0500, Mathieu Desnoyers wrote:
> > LTTng needs this symbol exported. It calls it to ensure its tracing
> > buffers and allocated data structures never trigger a page fault. This
> > is required to handle page fault handler tracing and NMI tracing
> > gracefully.
> 
> We:
> 
>  a) don't export symbols unless they have an intree-user

lttng is now in-tree in the drivers/staging/ area.  See linux-next for
details if you are curious.

>  b) especially don't export something as lowlevel as this one.

Mathieu, there's nothing else you can do to get this information?  Or
does lttng really want such lowlevel data?

thanks,

greg k-h
