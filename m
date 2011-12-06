Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1LFNQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:16:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1LFNQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:16:52 -0500
Date: Tue, 6 Dec 2011 11:16:34 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf tools: cleanups, fixes, updates
Message-ID: <20111206131634.GA7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <20111206110430.GK15738@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206110430.GK15738@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 12:04:30PM +0100, Robert Richter escreveu:
> On 06.12.11 11:32:30, Robert Richter wrote:
> > The patch set contains some cleanups, fixes and updates I found worth
> > to implement during code review. Some patches can be applied
> > independently.
> > 
> > Patches #1 and #2 are a repost.
> > 
> > Robert Richter (10):
> >   perf script: Fix mem leaks and NULL pointer checks around strdup()s
> >   perf script: Implement option for system-wide profiling

The two above were merged already in:

https://github.com/acmel/linux/commits/perf/core

> >   perf tools: Continue processing header on unknown features
> >   perf tools: Fix out-of-bound access to struct perf_session
> >   perf tool: Moving code in some files
> >   perf report: Setup browser if stdout is a pipe
> >   perf report: Accept fifos as input file
> >   perf tool: Unify handling of features when writing feature section
> >   perf tools: Improve macros for struct feature_ops
> >   perf tools: Use for_each_set_bit() to iterate over feature flags
> 
> I just realized conflicts with latest tip/perf/core. This applies on
> c23205c8488f11cb9ebe7a7b5851a1d8a0171011.
> 
> I can resent a rebased version but would like to wait for review
> first.

Ok, going thru them now.

- Arnaldo
