Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab0HTVfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0HTVfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:35:39 -0400
Date: Fri, 20 Aug 2010 18:34:48 -0300
From: "acme@redhat.com" <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
Message-ID: <20100820213447.GD2973@ghostprotocols.net>
References: <1282118350.5181.115.camel@rui> <1282134329.1926.3918.camel@laptop> <20100818124116.GA17957@console-pimps.org> <1282188497.11858.94.camel@minggr.sh.intel.com> <1282208521.1926.4535.camel@laptop> <1282268675.5181.1608.camel@rui> <1282296855.2605.724.camel@laptop> <20100820123159.GA3321@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820123159.GA3321@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 20, 2010 at 02:31:59PM +0200, Ingo Molnar escreveu:
> Btw., some 'perf list' thoughts. We could do a:
> 
>    perf list --help rapl:watts
> 
> Which gives the user some idea what an event does. Also, short descriptive 
> line in perf list output would be nice:
> 
> $ perf list
> 
> List of pre-defined events (to be used in -e):
> 
>   cpu-cycles OR cycles                       [Hardware event]   # CPU cycles
>   instructions                               [Hardware event]   # instructions executed
> 
>   ...
> 
>   rapl:watts                                 [Tracepoint]       # watts usage
> 
> or something like that. Perhaps even a TUI for perf list, to browse between 
> event types? (in that case it would probably be useful to make them collapse 
> along natural grouping)
> 
> We want users/developers to discover new events, see and understand their 
> purpose and combine them in not-seen-before ways.

Right, record, list, probe, top are on the UI (not just T-UI, see latest
efforts on decoupling from newt/slang) hit-list :)

Moving from one to the other seamlessly like today is possible for
report and annotate is the goal.

Now that the UI browser code is more robust and generic that should
happen faster, I think.

- Arnaldo
