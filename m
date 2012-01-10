Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2AJS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:59:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2AJS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:59:44 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Rgy2dYdRdCwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QHWksLyLfifrZNB3CiAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326221981.7642.49.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 10 Jan 2012 13:59:41 -0500
In-Reply-To: <20120110174509.GA30802@redhat.com>
References: <20120110174509.GA30802@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 18:45 +0100, Oleg Nesterov wrote:

> Obviously this is the user visible change. But personally I do
> agree with Seiji who requested this feature. Currently
> trace_signal_generate() just records the fact that __send_signal()
> was called, you can't know whether the signal was actually sent
> or not.

Adding more to a tracepoint is never an issue, even without a library to
parse the data correctly (which we still need in the distros). Thus this
change should have no issues.

-- Steve


