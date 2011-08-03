Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1HCRGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1HCRGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:06:44 -0400
Date: Wed, 3 Aug 2011 14:06:27 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
	unsupported ':r' modifier
Message-ID: <20110803170627.GB29321@ghostprotocols.net>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com> <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org> <1312369161.1147.292.camel@twins> <20110803113706.GA5768@somewhere.redhat.com> <1312371741.1147.301.camel@twins> <20110803115703.GB5768@somewhere.redhat.com> <1312373135.1147.308.camel@twins> <20110803121119.GC5768@somewhere.redhat.com> <1312373931.1147.314.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312373931.1147.314.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 03, 2011 at 02:18:51PM +0200, Peter Zijlstra escreveu:
> On Wed, 2011-08-03 at 14:11 +0200, Frederic Weisbecker wrote:
> > Look at tools/perf/util/parse-events.c:parse_single_tracepoint_event()
> 
> fscking tinkerers.. that's horrid... strncmp("record") seriously wtf
> were you smoking, Acme why did you ever merge crap like that?

I haven't :-)
 
> Also, acme that can break stuff, remember the whole different
> ->sample_format discussion?

Yes, the evsel/evlist abstractions were in part motivated by the
multiple perf_event_attr->sample_type in the same session.

Being 5 weeks AFK was really nice but left me with a rather large
backlog :-)

> /me stomps off and goes do something useful, this userspace is like all
> other userspace.. a steaming pile of shit.

Nah, its all code, no matter what side of the fence.

- Arnaldo
