Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1HCLnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:43:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1HCLnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:43:04 -0400
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110803113706.GA5768@somewhere.redhat.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
	 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
	 <1312369161.1147.292.camel@twins>
	 <20110803113706.GA5768@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 13:42:21 +0200
Message-ID: <1312371741.1147.301.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 13:37 +0200, Frederic Weisbecker wrote:
> On Wed, Aug 03, 2011 at 12:59:21PM +0200, Peter Zijlstra wrote:
> > On Fri, 2011-01-14 at 07:25 +0000, tip-bot for Stephane Eranian wrote:
> > > Looks to me like the :r modifier is not supported anymore, so remove it from
> > > the list of events. 
> > 
> > acme, why is that anyway? -R is a fun way to save some typing, but not
> > supporting :r anymore takes away the option of not getting
> > PERF_SAMPLE_RAW output for every event.
> 
> Because it was very non obvious for people to select this -R or :r
> every time they wanted to use trace events for tracing. I think
> there was complaints about that. Moreover nobody seemed to use
> trace events for non-tracing (perf report, top, annotate, ...)
> so we decided to always have RAW records so that it works for
> every cases...unless we lose events because of that.
> 
> We can still bring an option to force disabling of raw records.

That just doesn't compute, they still have to use -R, so what's the harm
in also having :r?

Also taking away options just because it confuses people sounds like
gnome, lets just not go there.
