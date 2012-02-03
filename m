Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2BCPlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:41:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2BCPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:40:59 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=mkvx9NrORpUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=LE_D0_u6xnaNxx-u_dMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328283656.5882.157.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 03 Feb 2012 10:40:56 -0500
In-Reply-To: <20111214163407.GE10791@somewhere.redhat.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
	 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
	 <20111213192556.GD2421@somewhere.redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
	 <20111214163407.GE10791@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 17:34 +0100, Frederic Weisbecker wrote:

> Well ftrace is a whole subsystem that includes the function tracer and also an interface
> for tracepoints in debugfs. I was rather suggesting the latter one. This is a good
> choice for background tracing. And it supports stacktraces. If those generate too much
> overhead perhaps you can tune the number of entries in the stacktrace, I don't remember
> if we can do that currently but this can be an interesting feature.

Setting individual stack tracing does sound like a neat feature. Maybe
even determine a limit of how much to backtrace. Trace the full stack,
or just trace a given amount of frames.

This shouldn't be too hard to implement.

-- Steve


