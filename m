Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab0ITRWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0ITRWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:22:33 -0400
Date: Mon, 20 Sep 2010 10:23:19 -0700
From: Greg KH <gregkh@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Roland McGrath <roland@redhat.com>, Ben Hawkes <hawkes@sota.gen.nz>
Subject: Re: planned 2.6.35.x -stable release for critical x86-64
	vulnerabilities ?
Message-ID: <20100920172319.GA8526@suse.de>
References: <20100920165320.GA28380@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920165320.GA28380@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:53:20PM -0400, Mathieu Desnoyers wrote:
> Hi Greg,
> 
> Sorry to have to ask this, but I was wondering about the ETA for the next round
> of -stable releases including fixes for the following bugs that seems to be
> actively exploited in the wild
> (http://blog.iweb.com/en/2010/09/64bits-linux-important-security-vulnerability-identified/5437.html
> http://isc.sans.edu/diary.html?storyid=9574):
> 
> CVE-2010-3081 (fixed by upstream
> commit c41d68a513c71e35a14f66d71782d27a79a81ea6)
> "compat: Make compat_alloc_user_space() incorporate the access_ok()"
> 
> and
> CVE-2010-3301 (fixed by upstream
> commit 36d001c70d8a0144ac1d038f6876c484849a74de
> "x86-64, compat: Test %rax for the syscall number, not %eax"
> and
> commit
> commit eefdca043e8391dcd719711716492063030b55ac
> "x86-64, compat: Retruncate rax after ia32 syscall entry tracing")
> 
> I'd like to rebase the LTTng tree on top of -stable as soon as it incorporates
> these fixes. I could just pull the fixes in my own tree, but this would be
> duplicated effort.
> 
> Again, sorry for the hassle, but I feel these bugs require immediate attention.

Does NOBODY frickin read my -rc stable announcements?  This is only the
8th email today that I've gotten about this issue.

{sigh}

I don't know why I even bother at times...

Sorry, I don't mean to take it out on you, but please people, at least
do some basic searching.  Like look at the -stable queue git tree which
shows that a -rc has been released and is under review, or look at the
lkml traffic, or, subscribe to the stable-review mailing list or look at
its archives.

greg k-h
