Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0JQKHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:07:24 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48073 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0JQKHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:07:22 -0400
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20101015225722.GA5354@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
	 <1286954453.29097.58.camel@twins>
	 <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
	 <20101014112000.GA5336@nowhere>
	 <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com>
	 <20101015225722.GA5354@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:07:03 +0200
Message-ID: <1287310023.1998.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 00:58 +0200, Frederic Weisbecker wrote:
> > Yes, PEBS does not capture the entire state.
> > 
> > Here is what you get on Intel Core:
> >         u64 flags, ip;
> >         u64 ax, bx, cx, dx;
> >         u64 si, di, bp, sp;
> >         u64 r8,  r9,  r10, r11;
> >         u64 r12, r13, r14, r15;

> Ok, that seems to cover most of the state. I guess few people care
> about cs, ds, es, fs, gs, most of the time. 

Yeah, except if you want to profile wine or something like that ;-)
