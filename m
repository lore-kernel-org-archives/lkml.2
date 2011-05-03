Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1ECOeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:34:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1ECOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:34:49 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=cRt4VtBUuUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_dR7CvpyjvujF_7lXZMA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110503142407.GC2893@sirena.org.uk>
References: <20110502211123.163877033@efficios.com>
	 <20110502213216.050459585@efficios.com>
	 <20110503132138.GL1762@opensource.wolfsonmicro.com>
	 <20110503140647.GA29665@Krystal> <20110503141436.GB2893@sirena.org.uk>
	 <20110503142407.GC2893@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 10:34:47 -0400
Message-ID: <1304433287.25414.2396.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 15:24 +0100, Mark Brown wrote:
> On Tue, May 03, 2011 at 03:14:37PM +0100, Mark Brown wrote:

> OK, now I see patch 1 I understand why you're doing this.  It should
> still be at least called out in the patch description if not actually
> split out into a separate patch (which would be ideal) - one of the
> things that really stands out in reviews is unrelated changes.

I actually think there should have been two different patch sets. One
for the semi colon clean up, and the other to do the work for arrays.
The semi colon clean up is non-controversial as it is just a clean up
that does not affect the current code at all.

But the added array preparation is not needed until we do the array
work, which deserves its own patch set.

-- Steve


