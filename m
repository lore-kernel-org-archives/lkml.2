Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2EGRGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:06:19 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:25068
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571Ab2EGRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:06:14 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz936eK146fI1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NWU2-02-BXP-02
X-M-MSG: 
Date: Mon, 7 May 2012 19:05:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] perf tools: Add parser for dynamic PMU events
Message-ID: <20120507170549.GM18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <1335983192-23731-4-git-send-email-robert.richter@amd.com>
 <1336388463.27020.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336388463.27020.3.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 13:01:03, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> > This patch adds support for pmu specific event parsers by extending
> > the pmu handler. The event syntax is the same as for tracepoints:
> > 
> >  <subsys>:<name>:<modifier> 
> 
> I really don't like this
> 
> > -          event_legacy_tracepoint sep_dc |
> > +          event_legacy_generic sep_dc |
> 
> That 'legacy' in there is a good hint you shouldn't be using this.
> 
> Ideally I'd get rid of all legacy formats eventually, we really
> shouldn't be adding new ones. 

Anyway, we need something like this to specify event names (pseudo
event names in case of ibs) and userland filter options. Though, it
must not necessarily this syntax but something else. The one above
looks esthetic to me while some other event syntax is close to a perl
regex. ;)

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

