Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1KPQpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:45:11 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1KPQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:45:09 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1321461693.4181.26.camel@frodo>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 17:45:02 +0100
Message-ID: <1321461902.4502.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 11:41 -0500, Steven Rostedt wrote:

> > That's possible, basically adding a tracepoints to printk -- that would
> > even catch everything and not require setting the console level (which
> > has its advantages too since other consoles might be slow).
> > 
> > It's a completely different thing though. I did it this way because it
> > was trivial to do out of tree for a quick test I was doing yesterday.
> > Doing it the other way is obviously more intrusive in core code.
> 
> I'm not sure it would be too invasive. Think you could get something
> working?

I briefly looked at it just after writing the email, but quickly got
lost in printk.c because of the multi-line handling it has. We could
instead trace each call to printk(), so the multi-line stuff would end
up in multiple events, but all of that code is too much vodoo for me :)

johannes

