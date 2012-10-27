Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2J0Xrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 19:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab2J0Xrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 19:47:47 -0400
Date: Sun, 28 Oct 2012 01:47:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf parser: does not support arbitrary new sysfs events
Message-ID: <20121027234728.GA22073@krava.redhat.com>
References: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
 <20121027203427.GB9099@krava.redhat.com>
 <CABPqkBSetRgY-+p6O1WK7=YgDzNZksU=deBnrbvWKipyJHQUTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSetRgY-+p6O1WK7=YgDzNZksU=deBnrbvWKipyJHQUTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 01:13:59AM +0200, Stephane Eranian wrote:
> On Sat, Oct 27, 2012 at 10:34 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Fri, Oct 26, 2012 at 10:23:09PM +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >> The latest round of perf parser changes broke my PEBS-LL patch series
> >> (at the last minute). For PEBS-LL, I need to add to generic events but I want
> >> to keep them PMU specific. As such, they need to live in the sysfs events
> >> subdir: /sys/devices/cpu/events/mem-loads, sys/devices/cpu/events/mem-stores.
> >>
> >> Given your latest rounds of sysfs event changes, I had to modify my kernel
> >> patches to fit those two new events within your perf_pmu_events_attr tables.
> >>
> >> But now, when I try to do:
> >>
> >> $ perf record -e cpu/mem-loads/ ....
> >
> > I can try this only on on uncore events and hw events aliases and that seems to work
> >
> I know it works there. I don't understand why it does not work with cpu/.
> 
> Just add an encoding that has no hardcoded equivalent. I bet you will
> reproduce the problem.
> 
> In my patch set, I have extended your perf_pmu_events_attr struct to
> also accept an already preformed event_str. I can send you that extension
> if you want.

that would be great

jirka
