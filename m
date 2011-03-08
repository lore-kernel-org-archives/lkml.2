Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1CHWmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:42:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1CHWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:42:41 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=WGQ-qfxG7m-jT8s5xbMA:9 a=Z9FnFxedjPvsyFVhy5b89DNduIsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1299622684.20306.77.camel@gandalf.stny.rr.com>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 17:42:38 -0500
Message-ID: <1299624158.20306.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 17:18 -0500, Steven Rostedt wrote:
> A few months ago it was suggested to have a way to enable tracepoints in
> a module when it is loaded. I tried various methods, but this one seems
> to be the least intrusive. In fact, it requires no modification to the
> module code.

I forgot to include the link to where this was brought up before:

https://lkml.org/lkml/2010/11/9/79

-- Steve


