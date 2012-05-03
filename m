Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2ECOXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:23:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2ECOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:23:38 -0400
Date: Thu, 3 May 2012 11:23:40 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
Message-ID: <20120503142340.GB8115@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
 <1335988003.13683.182.camel@twins>
 <20120502211805.GH5745@infradead.org>
 <1336032100.13683.193.camel@twins>
 <20120503130551.GA8115@infradead.org>
 <1336050734.22523.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336050734.22523.21.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 03:12:14PM +0200, Peter Zijlstra escreveu:
> On Thu, 2012-05-03 at 10:05 -0300, Arnaldo Carvalho de Melo wrote:
> > > Also, in this case the asm is dark blue, which is nearly invisible on my
> > > black background.
> > 
> > What colour do you suggest? Also what kind of term color scheme do you
> > use? Finding the right default combo is kinda hard. 
> 
> Yeah, I know.. I use white text on black background.
> 
> Typically for vim I use :se bg=dark
> 
> Anyway, I find it weird that the asm is coloured completely different
> between the two modes. If anything I would keep the asm as in the
> non-source variant and when you add the source, make that a different
> colour.

Its a bug, it should be coloured the same in both modes. Will implement
as you suggest.

- Arnaldo
