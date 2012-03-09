Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2CIMvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:51:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2CIMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:51:51 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=WmHxwEufuLI9dQ6WdCUA:9 a=yNyvlxNLWj2sGE9BiQsA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331297508.25686.573.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 09 Mar 2012 07:51:48 -0500
In-Reply-To: <alpine.LFD.2.02.1203091042040.2742@ionos>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	   <1331230991.25686.452.camel@gandalf.stny.rr.com>
	   <1331231287.11248.396.camel@twins>
	   <1331232159.25686.456.camel@gandalf.stny.rr.com>
	   <1331235579.11248.402.camel@twins>
	  <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203090111240.2742@ionos>
	 <1331261425.25686.527.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203091042040.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 11:23 +0100, Thomas Gleixner wrote:

> > Actually, you don't need to tell the lock owner you are waiting for it,
> > you only need to make the lock itself have a priority, and the owner
> > will inherit that priority as long as it holds the lock.
> 
> Hmm, that would actually work, though I'm not too enthusiastic about
> sched_yield().

I don't like sched_yield() either, but this is exactly what it was made
for. To give a process with the same priority the CPU.

-- Steve


