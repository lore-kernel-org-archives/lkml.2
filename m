Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0IVSoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:44:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:48537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0IVSoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:44:05 -0400
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <1285180574.26872.51.camel@gandalf.stny.rr.com>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	 <201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>
	 <201009180026.59482.trenn@suse.de>
	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	 <4C9A21AD.1000800@linux.intel.com>
	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
	 <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop>
	 <4C9A37AE.2010509@linux.intel.com>  <1285176629.2275.1033.camel@laptop>
	 <1285179355.26872.27.camel@gandalf.stny.rr.com>
	 <1285180000.2275.1036.camel@laptop>
	 <1285180574.26872.51.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 20:43:53 +0200
Message-ID: <1285181033.2275.1042.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 14:36 -0400, Steven Rostedt wrote:
> > I still don't see why you need TRACE_EVENT_ABI for that, if its the same
> > name and the format can be extended you get the same results with what
> > we've got. Apps need to read/parse the format thing anyway.
> 
> Just a marker that these trace points are being used by apps.

I really don't see any additional value in that. Its not like we won't
change them if we have to.

> But then again, we present the fields in the data. The tools should use
> a parse library (which a generic one will soon be out too). This way, we
> don't need them at the "end" but the parsing tools could find the fields
> no matter where they are in the record. 

Right. They should use the full format specification.
