Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2GFBm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:42:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38465 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2GFBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<87fw9blyhj.fsf@sejong.aot.lge.com>
	<20120702101518.GC967@krava.redhat.com>
	<1341234662.1476.13.camel@leonhard>
	<20120702133341.GD967@krava.redhat.com>
	<CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
	<CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
Date: Fri, 6 Jul 2012 03:42:54 +0200
Message-ID: <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Stephane Eranian <eranian@google.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 3:32 AM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Thu, Jul 5, 2012 at 12:15 PM, Stephane Eranian <eranian@google.com> wrote:
>> I don't understand why you actually need the :2 suffix. There can
>> only be one leader. So assume it is the first one. Users have to
>> know the first one is the leader which seems like a natural thing
>> to do for me. It would make you syntax less ugly than it already
>> is.
>
> In a blue sky world I would have done this.  In fact, this is what I
> tried before reading the sources to find out there is no group support
> so far.  But given that multiple -e options already have a meaning I
> would be hesitant to change this.

That's why I said you activate grouping via -e only when you have
the --group-events or --group-reads option in front. That would
not change the meaning of the multiple -e when none of those
group options are specified.
