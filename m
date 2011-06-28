Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1F1NTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:19:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab1F1NS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:18:26 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=VR3q0FbkgwYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kx0-NNX2TEBHvFvXhXAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip  00/13]tracing/kprobes: Dynamic events on module
 support
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 09:18:25 -0400
Message-ID: <1309267105.26417.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 16:26 +0900, Masami Hiramatsu wrote:
> Hi Steven,
> 
> Here, I'd like to push updates of dynamic events and perf-probe
> for supporting dynamic events on module.
> 
> The main part of this series is 1-5th patches for kprobes and
> dynamic event tracer, which allows us to add events on offline
> kernel module. This means we can put events even on the init
> functions of the drivers before loading. The requirement of
> this feature comes from my recent experience of a driver
> debugging. It had a timing bug in the initialization routine,
> and it was hard to catch them without tracing the behavior.
> 
> I added some perf-probe updates (which including some resent
> patches), And it's OK to pull only the main part (kprobes and
> ftrace patches) without perf updates.
> 

Thanks Masami,

I'll try to get to this this week. I've just been doing my main job at
the moment ;) Which surprisingly, has nothing to do with ftrace.

-- Steve


