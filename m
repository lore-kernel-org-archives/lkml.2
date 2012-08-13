Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab2HMJRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:17:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48783 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2HMJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:17:53 -0400
Date: Mon, 13 Aug 2012 11:17:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrey Wagin <avagin@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
Message-ID: <20120813091743.GC3471@gmail.com>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
 <1344247319-304069-3-git-send-email-avagin@openvz.org>
 <20120806181941.GG21441@infradead.org>
 <CANaxB-xq_wDGZQ16nTD6agwc_JiE4dQe1fXmvmPZckAX0EVr9w@mail.gmail.com>
 <20120806220000.GH21441@infradead.org>
 <20120806233146.GK21441@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806233146.GK21441@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> static int process_sample_event(struct perf_tool *tool __used,
>  				union perf_event *event,
>  				struct perf_sample *sample,
>				struct perf_evsel *evsel,
>  				struct machine *machine)

Just saw this 5-parameter function signature fly by: as a 
separate clean-up it would be really neat to stick most of these 
into an intuitively named helper structure or so. 

struct event_context ectx?

That would make extension of the context easier as well in the 
future. Or so.

Thanks,

	Ingo
