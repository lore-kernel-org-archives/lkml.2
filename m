Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1HFPSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:18:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58880 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1HFPSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:18:17 -0400
Date: Sat, 6 Aug 2011 17:18:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
Message-ID: <20110806151810.GC29058@somewhere>
References: <20110805205921.909038487@goodmis.org>
 <20110805212409.GA21114@elte.hu>
 <20110806004342.GG22164@somewhere>
 <20110806064847.GB13220@elte.hu>
 <20110806145655.GB29058@somewhere>
 <CAKYOsXw+Q+h2D++LxAoCUJ3tFVEhczBgDWNjwXzuJ0mNDav_Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYOsXw+Q+h2D++LxAoCUJ3tFVEhczBgDWNjwXzuJ0mNDav_Rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 09:16:58AM -0600, David Ahern wrote:
> On Sat, Aug 6, 2011 at 8:56 AM, Frederic Weisbecker <fweisbec@gmail.com>wrote:
> 
> > On Sat, Aug 06, 2011 at 08:48:47AM +0200, Ingo Molnar wrote:
> > > That is why i suggested libperf.so - this will handle the cases you
> > > mention, plus any future case - while still allow more flexible code
> > > sharing between libperf and the perf tools themselves.
> >
> > But what would you want inside libperf.o, further the trace event
> > library?
> >
> 
> 
> If the library is just for parsing trace events why not call it
> libtraceparse or libtrace? This isn't perf specific functionality.
> 
> David

This is what I don't understand yeah.
