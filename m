Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab1DAPPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:15:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DAPPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:15:52 -0400
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20110401151313.GC2335@nowhere>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
	 <20110324113209.20235.61900.stgit@localhost6.localdomain6>
	 <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com>
	 <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com>
	 <4D909BBB.5020500@gmail.com>  <20110401151313.GC2335@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 17:15:17 +0200
Message-ID: <1301670917.4859.696.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 17:13 +0200, Frederic Weisbecker wrote:
> On Mon, Mar 28, 2011 at 08:31:23AM -0600, David Ahern wrote:
> > On 03/28/11 04:34, Akihiro Nagai wrote:
> > >> from is sample->ip? to is sample->addr? In the above example
> > >> 0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
> > >> resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.
> > > Yes.
> > > In this example, resolved address is only sample->ip (branch from).
> > > We need the resolved address of sample->addr (branch to) too, because
> > > both of them are addresses of execution code.
> > 
> > Ok, now I understand. In that case add conversion of sample->addr to
> > symbols to perf-script.
> 
> I agree that we should rather use perf script for branch dumps.
> Sorry Akihiro, I think we suggested you to create this dedicated
> perf branch by the past. But then perf script became the vanilla dump
> tool in the middle and it seems more suitable today.
> 
> We can still create a perf branch later in order to produce some more
> advanced post-processing tools. But for sample dumps perf script (which starts
> to show itself as a misnomer BTW) seems to be the right place.

Why do something with snakes if its perfectly possible to do in C ?
