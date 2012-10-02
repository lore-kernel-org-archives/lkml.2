Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2JBAnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:43:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5851 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab2JBAnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:43:11 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wzlpjndgo3oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FfOpIHPiV7sA:10 a=VwQbUJbxAAAA:8 a=T_To3zQJ-HS0A9-Lf7AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349138589.22822.138.camel@gandalf.local.home>
Subject: Re: [PATCH v3 1/3] tracing,x86: add a TSC trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 01 Oct 2012 20:43:09 -0400
In-Reply-To: <CAJL_ekt5WZV_P71dwgJ3hYh4V08tJ41QJZCETq0P7EOo+uyN-Q@mail.gmail.com>
References: <1348148044.13080.59.camel@gandalf.local.home>
	 <1348181550-21931-1-git-send-email-dhsharp@google.com>
	 <1348888554.22822.108.camel@gandalf.local.home>
	 <CAJL_ekt5WZV_P71dwgJ3hYh4V08tJ41QJZCETq0P7EOo+uyN-Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 17:33 -0700, David Sharp wrote:

> > Unfortunately this isn't enough. You need to add a stub in all
> > arch/*/include/asm/ directories. That has:
> 
> Oh really? Okay. Sorry, I really don't know the mechanics of the arch
> trees. I'll work on that now, and then send you a new series since I
> forgot to send out my last update.

It's a good idea to cross compile archs, especially if you make any
change that affects archs (like this one did).

Just use ktest.pl. You can download the cross tools at:

  http://kernel.org/pub/tools/crosstool/files/bin/x86_64/

And you can use the example config file in:

  tools/testing/ktest/examples/crosstests.conf

That's basically the test I use to test cross compiling of other archs.

-- Steve


