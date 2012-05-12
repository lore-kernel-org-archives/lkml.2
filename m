Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2ELVZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 17:25:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2ELVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 17:25:41 -0400
Date: Sat, 12 May 2012 18:25:31 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
Message-ID: <20120512212531.GC20057@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 12, 2012 at 01:40:07PM -0700, Linus Torvalds escreveu:
> On Sat, May 12, 2012 at 12:52 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> > Arjan & Linus Annotation Edition
> 
> I pulled this into my current git tree just for testing.
> 
> It's horribly broken, but it's not the annotation that is broken.
> 
> The whole "-e cycles:pp" doesn't work any more. I don't get any nice
> PEBS information, I get the totally useless irq-based profiling.

> I don't think this has anything to do with your changes, but I thought
> I'd report it anyway. Something in 'perf' land is broken.

Didn't notice it, but then I'm not updating the kernel that frequently,
will check on this Sandy Bridge nobo (i7-2920XM).

- Arnaldo
