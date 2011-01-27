Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1A0SWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:22:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0SWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:22:33 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=yCYlo0vawIgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=c_QnHZwkaU93QJ_rHnQA:9 a=YDE5RW30ME8SqslkqlCS_LU-0g4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] tracepoints: Use __u64_aligned/U64_ALIGN()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20110127181907.GA5226@jolsa.brq.redhat.com>
References: <20110126040459.289776311@goodmis.org>
	 <20110126041014.987944521@goodmis.org>
	 <20110127181907.GA5226@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 27 Jan 2011 13:22:31 -0500
Message-ID: <1296152551.10144.80.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 19:19 +0100, Jiri Olsa wrote:

> this patch breaks tracepoint section iterating for me
> when trying to enable any event I get:

Yep we know. We are currently going through and reverting this with
something else.

Thanks!

-- Steve


