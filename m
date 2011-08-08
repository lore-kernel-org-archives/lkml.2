Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1HHNmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:42:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50870 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1HHNmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:42:52 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=frtdXJNUd71MEchLOYoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAM_iQpXwvP1S_cPtME5wYRZ5BkGNPebrCU2D6g4Mosse6md+rQ@mail.gmail.com>
References: <CAGZ=bq+mJ-9pf0Y22b9LLey0Em2Y7SAA5FnQ5cPsde6GB_aqgw@mail.gmail.com>
	 <1312666815.18583.221.camel@gandalf.stny.rr.com>
	 <CAM_iQpXwvP1S_cPtME5wYRZ5BkGNPebrCU2D6g4Mosse6md+rQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Aug 2011 09:42:50 -0400
Message-ID: <1312810970.18583.231.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 17:34 +0800, Américo Wang wrote:

> libkevent is still too generic, how about libtraceevent?

Hmm, I wanted to make it more generic than tracing, as it can be
profiling as well. But they do hook to tracepoints in the kernel, so
maybe libtracevent may be fine. Or libtracepoint.

-- Steve



