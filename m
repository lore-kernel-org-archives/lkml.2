Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1LTVrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:47:04 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:59804
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351Ab1LTVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:47:03 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275dhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EF10237.8040700@am.sony.com>
Date: Tue, 20 Dec 2011 13:46:31 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>, Greg KH <greg@kroah.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL modules
References: <1322776568.4699.52.camel@twins> <20111201221404.GC3365@kroah.com> <1322780830.4699.62.camel@twins> <20111201231751.GA4961@kroah.com> <20111205141749.GC28866@elte.hu> <20111206214446.GD1247@kroah.com> <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu>
In-Reply-To: <20111220110813.GA19105@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/11 03:08, Ingo Molnar wrote:
> 
> (Cc:-ing Arnaldo on this as well.)
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 

< snip >

> I think your concentration on ABIs is missing a very fundamental 
> property of instrumentation:
> 
>   the life-time and persistence of instrumentation data is 
>   typically very short ('days' is already an exception - typical 
>   is minutes, at most hours), and for that reason we havent been 
>   getting much pressure from users to maintain a perf.data ABI - 
>   but we are doing it nevertheless.
> 
> Instrumentation is fundamentally about the 'here and now' and so 
> it fundamentally differs from things like backup formats and 
> database formats. An ABI does not hurt and we are maintaining 
> it, but you are overrating its importance significantly.

Just to provide visibility to a different use case...

The life time of my data is typically weeks, months, or years
(though I am not likely to re-process year old raw data).

< snip >

-Frank

