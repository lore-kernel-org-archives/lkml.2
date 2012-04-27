Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001Ab2D0SJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:09:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:46741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760941Ab2D0SJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:09:27 -0400
Date: Fri, 27 Apr 2012 15:09:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120427180929.GI27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <20120427072153.GB4766@gmail.com>
 <20120427080613.GA7359@gmail.com>
 <20120427153119.GC27997@infradead.org>
 <1335541737.2463.135.camel@laptop>
 <20120427160748.GE27997@infradead.org>
 <1335543613.13683.112.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335543613.13683.112.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 06:20:13PM +0200, Peter Zijlstra escreveu:
> On Fri, 2012-04-27 at 13:07 -0300, Arnaldo Carvalho de Melo wrote:
> > Yeah, that too, or perhaps we can bring the instruction column closer to
> > the jump column and then that makes it stand out better? 
> 
> Well, there should be at least one space between the arrows and the
> instruction, otherwise it reads funny. And looking at the above that's
> already the case, except for that indenting you did.

Right, I just looked again at then unindented output, nevermind then :-)

- Arnaldo
