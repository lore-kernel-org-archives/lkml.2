Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2D1Ni3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 09:38:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2D1Ni2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 09:38:28 -0400
Date: Sat, 28 Apr 2012 10:38:26 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120428133826.GL27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
 <20120427164643.GG27997@infradead.org>
 <CA+55aFyZ+pMRn_Na_o5A3yWeUbXj2J_FVS8jbHgdD-UfPbOD5g@mail.gmail.com>
 <20120427180351.GH27997@infradead.org>
 <CA+55aFy2Erkros7qHpNBgbsGyP4azswTzWTFjSb2K4+KcFve2A@mail.gmail.com>
 <20120427191708.GJ27997@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427191708.GJ27997@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 04:17:09PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Apr 27, 2012 at 11:23:24AM -0700, Linus Torvalds escreveu:
> > On Fri, Apr 27, 2012 at 11:03 AM, Arnaldo Carvalho de Melo
> > > I should have reworded the "loop detection" with "basic jump arrows" in
> > > the first place.
> > 
> > .. and that is fine. But then you need to do it for *forwards* jumps
> > too. There is no difference between backwards and forwards jumps
> > *unless* you are looking for loops, and if you are looking for loops
> > you need to actually find the cycle.
> 
> Ok, so I changed things to not try to detect loops at all, for now, and
> instead just start with 'show jumps' on, hotkey 'j', that will draw
> arrows from jumps to its targets, backwards or forwards, when the cursor
> is on a jump instruction, take a look:

I pushed this one plus some more changes to my perf/annotate branch.

- Arnaldo
