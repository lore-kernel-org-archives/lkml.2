Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1FNCIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:08:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1FNCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:08:49 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=Uk49GNF6wVYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NgwK6HbEB4GcsH8oO8AA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 15/15] tracing/kprobes: Fix kprobe-tracer to support
 stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <4DF6B878.3060903@hitachi.com>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172914.290174627@goodmis.org> <20110613102118.GF30962@elte.hu>
	 <1307965484.9218.59.camel@gandalf.stny.rr.com>
	 <20110613115051.GE10960@elte.hu>
	 <1307967287.9218.64.camel@gandalf.stny.rr.com>
	 <4DF6B878.3060903@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 22:08:46 -0400
Message-ID: <1308017326.9218.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 10:25 +0900, Masami Hiramatsu wrote:

> I see, nowadays most of laptops has a wide screen (16:9) :P

<offtopic rant>

I totally hate this trend! I don't use computers to watch wide screen
movies! I use computers to do work. Who can get anything done with one
of these wide screen monitors?

I had to get my old LCD monitor restored, because I couldn't stand the
stupid wide screen I used to replace it. I find vertical space more high
valued real-estate than horizontal space.

The world is designed by idiots!

</offtopic rant>

-- Steve


