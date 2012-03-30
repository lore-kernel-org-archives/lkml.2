Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936433Ab2C3WCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:02:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:54861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935491Ab2C3WCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:02:04 -0400
Date: Fri, 30 Mar 2012 19:01:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 9/9] perf tools: Remove auto-generated bison/flex files
Message-ID: <20120330220152.GQ8482@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
 <1333123764-15662-10-git-send-email-acme@infradead.org>
 <87iphmm44e.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iphmm44e.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Mar 31, 2012 at 01:43:13AM +0900, Namhyung Kim escreveu:
> Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > +FLEX = $(CROSS_COMPILE)flex
> > +BISON= $(CROSS_COMPILE)bison
> 
> Just out of curiousity, is this $(CROSS_COMPILE) prefix really needed
> for flex/bison?

Possibly no, I just left it there when making Ingo's patch to get rid of
the pre-generated bison/flex files.

- Arnaldo
