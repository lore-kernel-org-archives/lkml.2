Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2HQRGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:06:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2HQRGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:06:25 -0400
Message-ID: <1345223165.29668.64.camel@twins>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@amd64.org>, Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Aug 2012 19:06:05 +0200
In-Reply-To: <1345216829.3708.33.camel@gandalf.local.home>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <20120816141253.0142ddd0@lwn.net>
	 <20120816205539.GA16308@aftab.osrc.amd.com>
	 <1345151613.3708.4.camel@gandalf.local.home>
	 <20120816214103.GE16308@aftab.osrc.amd.com>
	 <1345154418.3708.13.camel@gandalf.local.home>
	 <20120817073815.GA21017@aftab.osrc.amd.com>
	 <1345216829.3708.33.camel@gandalf.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 11:20 -0400, Steven Rostedt wrote:
> If it wasn't for sparc, we could have done this with the ftrace buffers,
> but sparc has some crazy requirement that physical pages can only be
> mapped at certain locations, and you can't just take a bunch of random
> pages and map them at the same location. 

same problem for perf.. I've meant to make it either mmap or splice but
not both, but I've never gotten around to actually implement any of
that.
