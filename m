Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1BCAnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:43:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1BCAnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:43:23 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=TcmrmW5AdGEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ahWYoqIDrD7bbWYf1jUA:9 a=KgGPGr9bpRL1KV61s1K5Loq5Nk0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] Tracepoints: Fix section alignment using pointer
 array
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.2.00.1102022318520.31804@localhost6.localdomain6>
References: <20110202180613.978219945@goodmis.org>
	 <20110202180938.471738176@goodmis.org>  <20110202183138.GB27022@Krystal>
	 <1296673015.10797.66.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1102022318520.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 19:43:20 -0500
Message-ID: <1296693800.10797.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 23:20 +0100, Thomas Gleixner wrote:

> Can you please use the common format
> 
>     commit 7e066fb8(what ever the subject line of the commit was)
> 
> That's way more helpful than a full sha1.
> 

OK, I'll rebase with this update. I'm currently testing the changes for
the syscall metadata (that has the same problem). When I'm done testing,
I'll post a new patch set with David's Acked-bys and this update.

-- Steve


