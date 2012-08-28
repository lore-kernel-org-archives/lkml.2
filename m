Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2H1QeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:34:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2H1QeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:34:13 -0400
Subject: Re: perf backtraces off-by-1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <503A6273.9090702@fb.com>
References: <5037FC9F.3090603@fb.com> <1345997415.2296.0.camel@laptop>
	 <503A6273.9090702@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 18:34:03 +0200
Message-ID: <1346171643.2296.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-26 at 10:52 -0700, Arun Sharma wrote:
> On 8/26/12 9:10 AM, Peter Zijlstra wrote:
> > On Fri, 2012-08-24 at 15:13 -0700, Arun Sharma wrote:
> >
> >>   One option is to support
> >> this for user mode only, with code to detect signal frames. Any other
> >> ideas?
> >>
> > I guess we'd need to see what that patch would look like... :-)
> >
> 
> It used to look like this:
> 
> http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=commitdiff;h=92cc7fd78a5a79c4bb5f85bfb7d7fb025df9cd5a

Hmm, that's not too bad, but a long stretch from pretty ;-)

How would you 'encode' this in the perf callchain data? 

> These days we just look at dwarf augmentation string:
> 
> http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=blob;f=src/dwarf/Gfde.c;h=8659624b0320c514057861a259b6efe1b605bbf3;hb=HEAD#l189

Right, except of course we don't have that in kernel..

BTW, are you in San Diego for LinuxCon/LPC etc?

