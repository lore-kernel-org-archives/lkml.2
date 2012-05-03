Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2ECP62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:58:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:42734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2ECP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:58:27 -0400
Date: Thu, 3 May 2012 12:58:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
Message-ID: <20120503155829.GB8807@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
 <1335988003.13683.182.camel@twins>
 <20120502211805.GH5745@infradead.org>
 <1336032100.13683.193.camel@twins>
 <20120503130551.GA8115@infradead.org>
 <1336050734.22523.21.camel@twins>
 <1336054267.1493.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336054267.1493.11.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 11:11:07PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> 2012-05-03 (목), 15:12 +0200, Peter Zijlstra:
> > On Thu, 2012-05-03 at 10:05 -0300, Arnaldo Carvalho de Melo wrote:
> > > > Also, in this case the asm is dark blue, which is nearly invisible on my
> > > > black background.
> > > 
> > > What colour do you suggest? Also what kind of term color scheme do you
> > > use? Finding the right default combo is kinda hard. 
> > 
> > Yeah, I know.. I use white text on black background.
> > 
> > Typically for vim I use :se bg=dark
> > 
> > Anyway, I find it weird that the asm is coloured completely different
> > between the two modes. If anything I would keep the asm as in the
> > non-source variant and when you add the source, make that a different
> > colour.
> > 
> 
> It was changed on commit 58e817d997d1 ("perf annotate: Print asm code as
> blue when source code is displayed") by me. I just tried to make the
> output as same as the --stdio one, but I felt bad on printing the whole
> asm lines as blue when no source is shown - I use similar color scheme
> of yours - so I just ended up leaving it to the default white.

I'll revert that one, I agree with Peter that we should have the same
color for asm with/without source code.

If you feel like source code should be in another color, then try to
find one that works well with some common term color schemes and propose
a patch.

- Arnaldo
