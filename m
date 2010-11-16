Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab0KPXcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:32:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab0KPXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:32:17 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=T9ZRXmIXaAQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8Lvq5K3y5wzke61OadwA:9 a=2RjfZYG0sXddb-DixYZ9wtJNHQkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTi=Y2X5EuqiCncPeNefgHs6vvGmnZpsyyddRR2g_@mail.gmail.com>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com>
	 <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
	 <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
	 <1287013830.3673.224.camel@frodo>
	 <AANLkTi=Y2X5EuqiCncPeNefgHs6vvGmnZpsyyddRR2g_@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Nov 2010 18:32:15 -0500
Message-ID: <1289950335.30543.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 15:27 -0800, David Sharp wrote:

> Steve, Mike told me that you may have some patches to improve overhead
> of syscall tracing. I'd be interested in testing them. Can you send
> them my way?

Mike may have been confused ;-)

I did tell him that some ring buffer improvements did make it into the
kernel. You might want to try the latest mainline again.

I even have other patches that might help. I'll have to go and dig them
up.

-- Steve


