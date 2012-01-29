Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2A2Qcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:32:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab2A2Qcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:32:45 -0500
Date: Sun, 29 Jan 2012 17:32:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Steets <asteets@rgmadvisors.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120129163235.GB23408@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F248938.5030507@rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Steets <asteets@rgmadvisors.com> wrote:

> On 1/28/12 6:01 AM, Ingo Molnar wrote:
> 
> >> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to 
> >> disable perf event counters.  Here is a demonstration 
> >> program:
> >
> > btw., what's your usecase?
> 
> I'm trying to profile a small section of a long-running 
> program.  I ran into trouble using call-graph recording and I 
> thought this might be an alternative way of getting what I was 
> after.

That usecase indeed makes sense. Peter, could we allow this for 
privileged tasks, depending on the perf_paranoia settings or 
such?

Thanks,

	Ingo
