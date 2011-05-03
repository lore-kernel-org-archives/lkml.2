Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab1ECHMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:12:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52878 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ECHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:12:49 -0400
Date: Tue, 3 May 2011 09:12:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503071215.GA18979@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503064046.GD7751@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:40:46AM -0400, Ingo Molnar wrote:
> I really like this new kernel/events/ subdirectory you created -

Yeah, this was your suggestion a couple of months ago, I just picked it
up.

> we could move the other perf_events.c facilities there as well, and
> maybe split up the file a bit, it's 7.5 KLOC now which is a bit
> excessive.

Right, so I left perf_event.c as a whole on purpose (only renamed)
because it makes more sense IMHO for someone who actually wrote it to
split it in logical parts (^hint hint^). I mean, I could do it too but
it'll take me much more time :).

> We should probably do that before adding kernel/events/persistent.c - wanna do 
> those changes? Initial commit should be a mostly-rename thing: 
> kernel/perf_events.c could move into kernel/events/core.c or so - and then we 
> could split the core up some more, into various facilities.
> 
> [ kernel/hw_breakpoint.c could possibly move into kernel/events/hw_breakpoint.c 
>   file as well - if Frederic acks it. ]

Yeah, no problem.

Thanks for the review, btw.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
