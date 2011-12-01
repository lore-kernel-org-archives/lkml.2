Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1LAV5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:57:20 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44338
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab1LAV5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:57:19 -0500
Date: Thu, 1 Dec 2011 16:57:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David McCullough <davidm@snapgear.com>,
        D Jeff Dionne <jeff@uClinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] mm: export vmalloc_sync_all symbol to GPL modules
Message-ID: <20111201215700.GA16782@infradead.org>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:41:13PM -0500, Mathieu Desnoyers wrote:
> LTTng needs this symbol exported. It calls it to ensure its tracing
> buffers and allocated data structures never trigger a page fault. This
> is required to handle page fault handler tracing and NMI tracing
> gracefully.

We:

 a) don't export symbols unless they have an intree-user
 b) especially don't export something as lowlevel as this one.

