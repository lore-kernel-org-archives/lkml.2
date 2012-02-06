Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2BFRRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab2BFRRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:17:43 -0500
Date: Mon, 6 Feb 2012 15:17:21 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, robert.richter@amd.com, eric.dumazet@gmail.com,
        Borislav Petkov <bp@amd64.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
	granularity on AMD
Message-ID: <20120206171721.GB6367@infradead.org>
References: <20120206132546.GA30854@quad> <1328538403.2482.4.camel@laptop> <CABPqkBRXc989vxb99S2y4thppjp8tFAxjWhCyC1Hvb897-s3EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBRXc989vxb99S2y4thppjp8tFAxjWhCyC1Hvb897-s3EQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 06, 2012 at 03:31:00PM +0100, Stephane Eranian escreveu:
> On Mon, Feb 6, 2012 at 3:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-02-06 at 14:25 +0100, Stephane Eranian wrote:
> >> In summary, two issues:
> >>   - Why is sched_clock_stable not set or even tested on recent AMD systems?
> >
> > I'll leave that for Robert to answer, also added Boris to the CC, him
> > know AMD bits too.
> >
> Ok, good.
> 
> >>   - perf should not rely on fine granularity timestamps in the re-ordering code
> >
> > Uhm, what else is there?

> I understand your point. I don't quite understand what the code is
> supposed to do for odered
> samples. I'd like Arnaldo to explain this warning first.

That code was written by Frédéric and IIRC also Thomas, its something I
plan to rework somehow in the future, but for now I'll let them chime
in... Frédéric?

- Arnaldo
