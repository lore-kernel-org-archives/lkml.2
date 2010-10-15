Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0JOTcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:32:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab0JOTcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:32:51 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=lH-zrpptVswA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9eRoCuG2rompOlRCxmcA:9 a=VTl-lY980-bxp5r2iqBQOCquKtgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1287154627.29097.1524.camel@twins>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.609332490@chello.nl>  <1287134043.29097.1331.camel@twins>
	 <1287154627.29097.1524.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 15:32:48 -0400
Message-ID: <1287171168.23682.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:57 +0200, Peter Zijlstra wrote:

> Ah, figured it out, it needs __attribute__((always_inline)), otherwise
> we end up with multiple keys for one label, which will clealy not work.
> 
> I thought we had a __force_inline macro but I can't seem to find that.

Do you mean __always_inline?

	See include/linux/compiler-gcc4.h

-- Steve



