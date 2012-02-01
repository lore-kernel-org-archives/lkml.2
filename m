Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2BANuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:50:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab2BANuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:50:19 -0500
Date: Wed, 1 Feb 2012 14:49:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120201134943.GC28547@elte.hu>
References: <20120126135504.GA13107@elte.hu>
 <1327586669.22710.89.camel@gandalf.stny.rr.com>
 <1327588606.22710.100.camel@gandalf.stny.rr.com>
 <20120126183946.GA14709@elte.hu>
 <87ehuldf0m.fsf@rustcorp.com.au>
 <1327924333.22710.157.camel@gandalf.stny.rr.com>
 <87sjiwjzew.fsf@rustcorp.com.au>
 <20120131122016.GF32010@elte.hu>
 <1328014230.5882.29.camel@gandalf.stny.rr.com>
 <87y5snhwwd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5snhwwd.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Applied,
> Rusty.
> 
> From: Steven Rostedt <rostedt@goodmis.org>

> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (made all out-of-line)

Steve's SOB seems to be missing.

Thanks,

	Ingo
