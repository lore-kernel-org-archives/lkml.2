Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2I1F6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 01:58:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63761 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2I1F6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 01:58:07 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-63-50653c6c24c2
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	<87pq5awvgp.fsf@sejong.aot.lge.com>
	<20120927230138.GA10660@somewhere.redhat.com>
Date: Fri, 28 Sep 2012 14:49:55 +0900
In-Reply-To: <20120927230138.GA10660@somewhere.redhat.com> (Frederic
	Weisbecker's message of "Fri, 28 Sep 2012 01:01:48 +0200")
Message-ID: <874nmivgqk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Fri, 28 Sep 2012 01:01:48 +0200, Frederic Weisbecker wrote:
> When Arun was working on this, I asked him to explore if it could make sense to reuse
> the "-b, --branch-stack"  perf report option. Because after all, this feature is doing
> about the same than "-b" except it's using callchains instead of full branch tracing.
> But callchains are branches. Just a limited subset of all branches taken on excecution.
> So you can probably reuse some interface and even ground code there.
>
> What do you think?

Umm.. first of all, I'm not familiar with the branch stack thing.  It's
intel-specific, right?

Also I don't understand what exactly you want here.  What kind of
interface did you say?  Can you elaborate it bit more?

And AFAIK branch stack can collect much more branch information than
just callstacks.  Can we differentiate which is which easily?  Is there
any limitation on using it?  What if callstacks are not sync'ed with
branch stacks - is it possible though?

But I think it'd be good if the branch stack can be changed to call
stack in general.  Did you mean this?

Thanks,
Namhyung
