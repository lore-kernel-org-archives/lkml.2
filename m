Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CJXRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:17:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1CJXRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:17:24 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=BreIgDS8JPAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=T7BzFCFmKU5wi8u9-YYA:9 a=Gwes_-kix18C9Xj7O1zgG3PZWi0A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH perf 0/2] perf: trace-event-parse: support more
 operators and print formats
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1299797756-13546-1-git-send-email-dhsharp@google.com>
References: <1299797756-13546-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 18:17:23 -0500
Message-ID: <1299799043.15854.488.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Cc for Arnaldo and Frederic ]

-- Steve


On Thu, 2011-03-10 at 14:55 -0800, David Sharp wrote:
> These patches correspond to similar patches recently applied to trace-cmd
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Stephane Eranian <eranian@google.com>
> 
> David Sharp (2):
>   perf: trace-event-parse: support additional operators: '!', '~',  and
>     '!='
>   perf: trace-event-parse: support printing short fields
> 
>  tools/perf/util/trace-event-parse.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 


