Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1KYRvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:51:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1KYRvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:51:49 -0500
Date: Fri, 25 Nov 2011 15:51:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, mingo@redhat.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        efault@gmx.de, peterz@infradead.org, Arun Sharma <asharma@fb.com>
Subject: Re: strace based on perf [Re: libperf interface stability]
Message-ID: <20111125175140.GD7098@infradead.org>
References: <new-submission> <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org> <20111124162845.GB7795@erda.amd.com> <20111124181052.GA4058@infradead.org> <4ECE98CD.7060902@gmail.com> <4ECFD16F.8090305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECFD16F.8090305@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 25, 2011 at 10:33:35AM -0700, David Ahern escreveu:
> On 11/24/2011 12:19 PM, David Ahern wrote:
> > On 11/24/2011 11:10 AM, Arnaldo Carvalho de Melo wrote:
> >> I have a branch that I explicitely mark as unstable where I'm putting
> >> what I have at:
> >>
> >> https://github.com/acmel/linux/commits/tmp.perf/trace4
> 
> I don't see the strace command in this branch.

Its not there yet, lemme check some stuff here and I'll push it, but
still has ways to go. It'll be on tools/perf/builtin-trace.c

For the reference implementation I'll be picking code/ideas from:

https://github.com/acmel/linux/tree/tmp.perf/trace2

This is what Thomas, Ingo et al came to in '10.

That was done with the tooling infrastructure at that point in time,
lotsa happened since then and there are still more to do for me to get
into it confortably.

Take a look, probably some of your questions will be answered there.

- Arnaldo
