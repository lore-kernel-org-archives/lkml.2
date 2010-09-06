Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0IFI4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:56:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64559 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0IFI4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:56:51 -0400
MIME-Version: 1.0
X-Originating-IP: [81.243.35.243]
In-Reply-To: <20100904081801.GA19876@elte.hu>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
	<201009032005.08268.trenn@suse.de>
	<20100903195555.GA1663@elte.hu>
	<201009032210.08524.trenn@suse.de>
	<4C817D0E.6020702@linux.intel.com>
	<20100904081801.GA19876@elte.hu>
Date: Mon, 6 Sep 2010 10:56:50 +0200
Message-ID: <AANLkTinrRoi6y1fKUevu2O-Diac5B2r8RftTWUigQZOh@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the feedback!

> On Friday 03 September 2010 21:55:55 Ingo Molnar wrote:
>Well, the patch that got posted:
>
> [PATCH] tracing, perf: add more power related events
>
>Only adds tracepoints to power.h, but doesnt actually use them anywhere
>...
>
>Is there a companion patch i missed?
I will re-start a thread with the full patch and with both lkml and
linux-omap in Cc.

>Also, it would be nice to add it to x86 and to OMAP at once, and
>synchronize up all the power events - and check how existing tools like
>powertop make use of such events - and sync it all up. We dont want to
>have inconsistent, architecture-dependent events in the end, for obvious
>reasons.
Indeed that is the idea to sync up all power events. Other new events
will follow shortly, e.g. low power transitions latency profiling etc.

Wrt the tools, I would be glad to contribute to the tools. I already
have local patches to pytimechart. Other tools like powertop,
cpufrequtils can be patched as well.

Thanks,
Jean
