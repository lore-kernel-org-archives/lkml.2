Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1EJKsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:48:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1EJKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:48:17 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=9AX6eWKuMFgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=1z2FRG9S8Gsp-Ti4SeIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 00/13] ftrace: Allow multiple users to pick and
 choose functions to trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>
In-Reply-To: <20110510080029.GA27426@elte.hu>
References: <20110506152624.776982312@goodmis.org>
	 <20110510080029.GA27426@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 04:32:18 -0400
Message-ID: <1305016338.2968.19.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 10:00 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> Well, i think we'd like to see the end result as well: i.e. function tracing 
> exposed to a tracer that can do per task tracing (perf) and then demonstrating 
> that independent tracing sessions can trace functions without impacting each 
> other.

This could be done. I just wanted to post this RFC for now, just in case
someone found an issue with this design. When I get back home, I'll
complete this, and work with Frederic to get a RFC patch set with perf
working.

I don't want to rush this out as it can get complex and I want us to
"learn" the correct way of enabling this for perf. Although, it would be
nice to get this into 2.6.40. Perhaps we should be conservative and aim
for 2.6.41 and let it settle for a release.

-- Steve


