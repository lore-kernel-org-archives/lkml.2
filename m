Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2J3IWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:22:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:52242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2J3IWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:22:03 -0400
Message-ID: <1351585291.4047.34.camel@twins>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 30 Oct 2012 09:21:31 +0100
In-Reply-To: <20121030081807.GA8245@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
	 <20121026145451.GA14379@gmail.com>
	 <20121026170503.GC20695@ghostprotocols.net>
	 <20121027131935.GA30001@gmail.com> <20121030081807.GA8245@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 09:18 +0100, Ingo Molnar wrote:
> > > The optimal way, I guess, would be to have some cache file 
> > > with the results of such feature tests, that would be created 
> > > and then used till the build fails using its findings, which 
> > > would trigger a new feature check round, followed by an 
> > > automatic rebuild. 

autoconf!! ;-)

/me runs
