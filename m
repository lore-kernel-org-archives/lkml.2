Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0ITQxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:53:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56635 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753587Ab0ITQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:53:22 -0400
Date: Mon, 20 Sep 2010 12:53:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Roland McGrath <roland@redhat.com>, Ben Hawkes <hawkes@sota.gen.nz>
Subject: planned 2.6.35.x -stable release for critical x86-64
	vulnerabilities ?
Message-ID: <20100920165320.GA28380@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:39:30 up 240 days, 19:16,  6 users,  load average: 0.00, 0.03,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Sorry to have to ask this, but I was wondering about the ETA for the next round
of -stable releases including fixes for the following bugs that seems to be
actively exploited in the wild
(http://blog.iweb.com/en/2010/09/64bits-linux-important-security-vulnerability-identified/5437.html
http://isc.sans.edu/diary.html?storyid=9574):

CVE-2010-3081 (fixed by upstream
commit c41d68a513c71e35a14f66d71782d27a79a81ea6)
"compat: Make compat_alloc_user_space() incorporate the access_ok()"

and
CVE-2010-3301 (fixed by upstream
commit 36d001c70d8a0144ac1d038f6876c484849a74de
"x86-64, compat: Test %rax for the syscall number, not %eax"
and
commit
commit eefdca043e8391dcd719711716492063030b55ac
"x86-64, compat: Retruncate rax after ia32 syscall entry tracing")

I'd like to rebase the LTTng tree on top of -stable as soon as it incorporates
these fixes. I could just pull the fixes in my own tree, but this would be
duplicated effort.

Again, sorry for the hassle, but I feel these bugs require immediate attention.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
