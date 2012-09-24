Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2IXPvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:51:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48089 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756574Ab2IXPvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:51:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/9uXhSD+z9jSaAmTkPmDIcdfcfR1Wb87dYRlNs0H
	rvwuQrjGSdmePv
Message-ID: <1348501868.6991.230.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 24 Sep 2012 17:51:08 +0200
In-Reply-To: <1348500647.11847.69.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 17:30 +0200, Peter Zijlstra wrote:

> Anyway, does anybody have any clue as to why AMD and Intel machine
> behave significantly different here? Does an Intel box with HT disabled
> behave similar to AMD? or is it something about the micro-architecture?

If you mean pgbench, it should act about the same on both.  As soon as
pgbench starts using significant CPU and has to compete, it'll start
having trouble.

-Mike

