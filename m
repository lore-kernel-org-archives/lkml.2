Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab0KSBlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:41:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0KSBle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:41:34 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=T9ZRXmIXaAQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=knx9HKqwbM99dawkhRAA:9 a=UkXUt4oP3n7D1Nqyj9pnS60dX5kA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTimrgXbZxQKjapXkDgYRZqdZkfe1eUdFTAu=+Q8f@mail.gmail.com>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com>
	 <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
	 <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
	 <1287013830.3673.224.camel@frodo>
	 <AANLkTi=Y2X5EuqiCncPeNefgHs6vvGmnZpsyyddRR2g_@mail.gmail.com>
	 <1289950335.30543.8.camel@gandalf.stny.rr.com>
	 <AANLkTimrgXbZxQKjapXkDgYRZqdZkfe1eUdFTAu=+Q8f@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 20:41:31 -0500
Message-ID: <1290130891.30543.127.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 17:11 -0800, Michael Rubin wrote:

> > I did tell him that some ring buffer improvements did make it into the
> > kernel. You might want to try the latest mainline again.
> 
> You told me that you had patches (in 2.6.37) I think that would allow
> us to specifically improve the syscall tracing performance.
> 
> Can you point us at em?

Look at commits:

afcc5c6872f0215d515a637041bb51f8691a8ea7
69d1b839f7eee347e357b3f6cce7f630cc6ff93d
140ff89127c74b1b1c1b0152a36ea3720ccf6bc3
d9abde2138e0a00a0d7e44676928efa0ef629d48
b8b2663bd7c9da04ac804659b9f617c199d0252c

-- Steve


