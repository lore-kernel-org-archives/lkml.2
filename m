Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775Ab2D0Qqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:46:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2D0Qqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:46:39 -0400
Date: Fri, 27 Apr 2012 13:46:43 -0300
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
Message-ID: <20120427164643.GG27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 09:35:58AM -0700, Linus Torvalds escreveu:
> Btw, don't get me wrong. I really like the changes. It's just that now
> that the asm is almost readable, the remaining stupid default decode
> format details just show up so much more clearly.

Hey, I love the comments and suggestions, keep them coming when you feel
like doing it.

- Arnaldo
