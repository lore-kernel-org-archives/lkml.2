Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1FNLXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:23:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab1FNLXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:23:21 -0400
Subject: Re: [PATCH 15/15] tracing/kprobes: Fix kprobe-tracer to support
 stack trace
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <1308017326.9218.111.camel@gandalf.stny.rr.com>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172914.290174627@goodmis.org> <20110613102118.GF30962@elte.hu>
	 <1307965484.9218.59.camel@gandalf.stny.rr.com>
	 <20110613115051.GE10960@elte.hu>
	 <1307967287.9218.64.camel@gandalf.stny.rr.com>
	 <4DF6B878.3060903@hitachi.com>
	 <1308017326.9218.111.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 13:22:48 +0200
Message-ID: <1308050568.19856.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 22:08 -0400, Steven Rostedt wrote:
> On Tue, 2011-06-14 at 10:25 +0900, Masami Hiramatsu wrote:
> 
> > I see, nowadays most of laptops has a wide screen (16:9) :P
> 
> <offtopic rant>
> 
> I totally hate this trend! I don't use computers to watch wide screen
> movies! I use computers to do work. Who can get anything done with one
> of these wide screen monitors?

I've got 2 16:10 screens, yielding 8 columns of text ~90 chars wide.

> I had to get my old LCD monitor restored, because I couldn't stand the
> stupid wide screen I used to replace it. I find vertical space more high
> valued real-estate than horizontal space.
> 
> The world is designed by idiots!

*grin*, I fully concur though, this 16:9 craze is totally annoying. The
worst part is that you cannot even vote with your wallet, its impossible
to buy a laptop without 16:9 screen these days.

fwiw, I didn't mind the 1600x1200 -> 1920x1200 step, that was same
height yet more pixels, yay!

But 16:9 is utter crap, the other totally annoying thing is that people
are forced to use these totally insane low-res screens. Most 12-15"
laptops come with a resolution about equal to the latest iPhone, fsck
that. I want a 12-13" with that same 300ppi ;-)

Screen resolution used to go up, but ever since this HD-tv crap
(720p/1080i should be shot in the head) got popular screen res went
down! /me can't wait for this 4K format to become popular.

> </offtopic rant>

