Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2ECOM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:12:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2ECOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:12:57 -0400
X-Authority-Analysis: v=2.0 cv=N/Wr5hBB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=YECtLpki0LgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Er_tMXHLL19sWfeMzaQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336054375.14207.84.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v6 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 10:12:55 -0400
In-Reply-To: <1336049840.14207.82.camel@gandalf.stny.rr.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
	 <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336010118.14207.75.camel@gandalf.stny.rr.com>
	 <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
	 <1336049840.14207.82.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 08:57 -0400, Steven Rostedt wrote:

> So it seems to be trace-cmd doing something different that prevents the
> expand from happening. Not sure what it is. If I get time, I'll
> investigate it a little more.

Do the following:

echo 0 > /debug/tracing/tracing_on
echo nop  > /debug/tracing/current_tracer

then look at buffer_size_kb.

It's also giving me errors when I try to enable events or anything else
when tracing_on is disabled.

-- Steve


