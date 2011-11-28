Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1K1UQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:16:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1K1UQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:16:17 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=jMOZBfb3lLUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=rcC7Z8CIbsXwdEZJI5QA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <1322511002.2921.171.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo> <1322510931.2921.170.camel@twins>
	 <1322511002.2921.171.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:16:15 -0500
Message-ID: <1322511375.17003.25.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:10 +0100, Peter Zijlstra wrote:

> > Yeah, but still not something you want to do during context switches,
> > right? 
> 
> Also, that's x86, there's still archs that need stop_machine(), right?

s390 may need it, but till we add a work around there too.

But yeah, if this happens at context switch, then we want the fast
enable/disable that Jiri made.

-- Steve



