Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab1KPPKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:10:40 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43099
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab1KPPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:10:39 -0500
Date: Wed, 16 Nov 2011 10:10:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: add trace console
Message-ID: <20111116151037.GA26166@infradead.org>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 11:18:48AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As described in the Kconfig entry, logging printk
> output is useful to correlate (existing) printk
> debugging with (existing) tracing. The easiest way
> to achieve this is to register a console that just
> calls trace_printk(), which this module does.

I'd much prefer if we could have it built in all the time, but had a
way to enable it at runtime, just like all the "real" tracepoints.

