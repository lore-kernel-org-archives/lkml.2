Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370Ab2JZQc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:32:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:46332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257Ab2JZQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:32:26 -0400
Date: Fri, 26 Oct 2012 09:31:15 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121026163115.GA20695@ghostprotocols.net>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <508AA709.7010202@gmail.com>
 <1351265502.1619.13.camel@leonhard>
 <20121026153431.GA5230@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026153431.GA5230@x1.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 26, 2012 at 05:34:32PM +0200, Borislav Petkov escreveu:
> On Sat, Oct 27, 2012 at 12:31:42AM +0900, Namhyung Kim wrote:
> > You can see it easily when building perf without -j option. But I have
> > no idea why it takes so long..
 
> Well, you can trace that workload with perf itself, no, and see the
> hotspots.

Right, perf'ing perf is a favourite pastime, right?

- Arnaldo
