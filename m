Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2J3JOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:14:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54876 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2J3JOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:14:45 -0400
Date: Tue, 30 Oct 2012 10:14:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121030091440.GA10272@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
 <1351585291.4047.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351585291.4047.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2012-10-30 at 09:18 +0100, Ingo Molnar wrote:
> > > > The optimal way, I guess, would be to have some cache file 
> > > > with the results of such feature tests, that would be created 
> > > > and then used till the build fails using its findings, which 
> > > > would trigger a new feature check round, followed by an 
> > > > automatic rebuild. 

I did not write that.

I think making the feature tests parallel would be enough to 
speed it all up - caching brings in a new set of problems. The 
tests are mostly independent and the feature test makefile rules 
could be parallelized like the object file rules.

> autoconf!! ;-)
> 
> /me runs

hey, we build perf much faster than autoconf's 'configure' 
script finishes running ;-)

Thanks,

	Ingo
