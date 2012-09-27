Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2I0H4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:56:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33429 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752550Ab2I0Hz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:55:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19lNTAqkFVlpXA1UVQwyecTA8Tf8A9Hl6AoeFFCSG
	Ay3bQVJVKY0MJo
Message-ID: <1348732552.7059.189.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: david@lang.hm
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 09:55:52 +0200
In-Reply-To: <alpine.DEB.2.02.1209270013270.5162@asgard.lang.hm>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <alpine.DEB.2.02.1209270013270.5162@asgard.lang.hm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 00:17 -0700, david@lang.hm wrote:

> over the long term, the work lost due to not moving optimally right away 
> is probably much less than the work lost due to trying to figure out the 
> perfect thing to do.

Yeah, "Perfect is the enemy of good" definitely applies.  Once you're
ramped, less is more.

-Mike

