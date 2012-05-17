Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280Ab2EQIFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:05:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61652 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761318Ab2EQIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:04:46 -0400
Date: Thu, 17 May 2012 10:04:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
Message-ID: <20120517080433.GB17419@gmail.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
 <4FB401B2.1010906@linux.intel.com>
 <CA+55aFyGkxwmzqca6GZmQzwTbU_TL_SWeBUpHfcWWiOQro2Ruw@mail.gmail.com>
 <1337198622.6724.83.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337198622.6724.83.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Ok. Sadly, my actual laptop (which is where I've used it) 
> > runs F17 these days, since F14 can't handle the SNB 
> > graphics. So I'd actually notice.
> > 
> > Steven is foiled again.
> 
> /me curses! That damn rascal Linus!

Binary compatibility's a bitch!

But yeah, since this is instrumentation, the rules are somewhat 
relaxed to current widespread installations of tools, because 
few people are running old tools on old kernels to produce new 
code against new kernels, right?

Thanks,

	Ingo
