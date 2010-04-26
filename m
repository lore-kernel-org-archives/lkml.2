Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0DZUWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:22:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0DZUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:22:32 -0400
X-Authority-Analysis: v=1.1 cv=OQt9FTpBtG7aVA3iIcO4n/15BLkw2hRg/WlL4r7+KMc= c=1 sm=0 a=mWQjLl1nR8kA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=leD5DTHNUu-eLTKLX7IA:9 a=VjlsKlO8ihKgl3GvEC4A:7 a=oVuExRga5i7hcu3ljs7pqeKoRDAA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv6 0/4] tracing: function graph output for
 preempt/irqs-off tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 26 Apr 2010 16:22:30 -0400
Message-ID: <1272313350.9739.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 19:01 +0200, Jiri Olsa wrote:
> hi,
> 
> updates based on comments by Frederic Weisbecker,
> also rebase to latest master.
> 
> I'm sending reworked version of the graph output support for
> preemptirqsoff/preemptoff/irqsoff tracers.
> 


Hi Jiri,

I haven't forgotten about you. I came back from the Linux Collaboration
Summit with a bunch of TODO's and one of them took me all week. I spent
the entire week hacking the ftrace.h file which takes up 100% of my
concentration, so I never got to look at your patches.

Your patch set is next on my todo list, so expect feedback from me
either later today or tomorrow.

Thanks for you patience,

-- Steve


