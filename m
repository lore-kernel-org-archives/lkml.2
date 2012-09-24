Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2IXS0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:26:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39235 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757247Ab2IXS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:26:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QhuwZILkQ8iUrNOL11caVSoAoSgUiur8jsDR9Zg
	OKAqzHtN2qvlvB
Message-ID: <1348511193.6951.44.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Mon, 24 Sep 2012 20:26:33 +0200
In-Reply-To: <1348505683.11847.111.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
	 <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 18:54 +0200, Peter Zijlstra wrote: 
> On Mon, 2012-09-24 at 09:30 -0700, Linus Torvalds wrote:

> > Also, do we really want to spread things out that aggressively?
> > How/why do we know that we don't want to share L2 caches, for example?
> > It sounds like a bad idea from a power standpoint, and possibly
> > performance too.
> 
> IIRC this current stuff is the result of Mike and Suresh running a few
> benchmarks.. Mike, Suresh, either one of you remember this? Otherwise
> I'll have to go trawl the archives.

Aside from the cache pollution I recall having been mentioned, on my
E5620, cross core is a tbench win over affine, cross thread is not.

-Mike

