Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1BQULq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:11:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922Ab1BQULo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:11:44 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=N3ZPZhDW9-CjWhLS7bIA:9 a=fhtVCNF29TFJSaNUoBh9vVkg-lgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4D5D47C0.9020206@hitachi.com>
References: <20110209200249.111932716@goodmis.org>
	 <4D5D1672.6070206@hitachi.com>
	 <1297948703.23343.907.camel@gandalf.stny.rr.com>
	 <4D5D4013.4070602@hitachi.com>
	 <1297957591.23343.921.camel@gandalf.stny.rr.com>
	 <4D5D47C0.9020206@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 15:11:41 -0500
Message-ID: <1297973501.23343.953.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 01:07 +0900, Masami Hiramatsu wrote:

> I just thought that frequent stop-machine is not so good from the user's
> POV. I agree that disabled probe ignoring the call is enough.
> Maybe, it could be done with the similar mechanism of jump optimization.

I thought jump optimization still calls stop_machine too?

-- Steve


