Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab2J0NTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:19:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43901 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2J0NTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:19:40 -0400
Date: Sat, 27 Oct 2012 15:19:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121027131935.GA30001@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026170503.GC20695@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Fri, Oct 26, 2012 at 04:54:51PM +0200, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > . Makefile improvements from Namhyung Kim.
> > 
> > These are really useful: there used to be a couple of 
> > seconds of wait time at the beginning of every perf build - 
> > these are now nicely explained with the various CHK entries.
> 
> The optimal way, I guess, would be to have some cache file 
> with the results of such feature tests, that would be created 
> and then used till the build fails using its findings, which 
> would trigger a new feature check round, followed by an 
> automatic rebuild.
> 
> That would be tricky because we would have to have an 
> automated way of discovering if the build failed due to 
> missing packages or if it failed due to some ordinary coding 
> mistake.

The feature tests aren't a big problem right now - but making it 
*visible* is really useful. It also tells us which feature test 
fails, etc.

Thanks,

	Ingo
