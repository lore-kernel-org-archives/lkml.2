Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2A3Jwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:52:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:59525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2A3Jwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:52:51 -0500
Message-ID: <1327917156.2446.191.camel@twins>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Steets <asteets@rgmadvisors.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 30 Jan 2012 10:52:36 +0100
In-Reply-To: <20120129163235.GB23408@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
	 <20120128120151.GA10390@elte.hu> <4F248938.5030507@rgmadvisors.com>
	 <20120129163235.GB23408@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-29 at 17:32 +0100, Ingo Molnar wrote:
> * Andrew Steets <asteets@rgmadvisors.com> wrote:
> 
> > On 1/28/12 6:01 AM, Ingo Molnar wrote:
> > 
> > >> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to 
> > >> disable perf event counters.  Here is a demonstration 
> > >> program:
> > >
> > > btw., what's your usecase?
> > 
> > I'm trying to profile a small section of a long-running 
> > program.  I ran into trouble using call-graph recording and I 
> > thought this might be an alternative way of getting what I was 
> > after.
> 
> That usecase indeed makes sense. Peter, could we allow this for 
> privileged tasks, depending on the perf_paranoia settings or 
> such?

I really dislike it. The sane way around this would be to allow easy
self-profiling instead of doing things arse about face like that.
