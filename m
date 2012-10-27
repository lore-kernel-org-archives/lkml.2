Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2J0OaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:30:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2J0OaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:30:02 -0400
Date: Sat, 27 Oct 2012 07:29:01 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>, Borislav Petkov <bp@amd64.org>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121027142901.GF20695@ghostprotocols.net>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <508AA709.7010202@gmail.com>
 <1351265502.1619.13.camel@leonhard>
 <20121026153431.GA5230@x1.osrc.amd.com>
 <20121026163115.GA20695@ghostprotocols.net>
 <20121026172018.GA14116@liondog.tnic>
 <1351329391.1498.4.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351329391.1498.4.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 27, 2012 at 06:16:31PM +0900, Namhyung Kim escreveu:
> 2012-10-26 (금), 19:20 +0200, Borislav Petkov:
> > On Fri, Oct 26, 2012 at 09:31:15AM -0700, Arnaldo Carvalho de Melo wrote:
> > > Right, perf'ing perf is a favourite pastime, right?
> > 
> > Sure, can I get "perfing perf" on a T-shirt please?
> 
> Well, guys, this is not perfing perf.  It's about perfing make and/or
> gcc.  Anyway I'd also like to get a "perfing perf" T-shirt. ;)

Well, building perf faster will allow us to perf perf faster. ;-)

- Arnaldo
