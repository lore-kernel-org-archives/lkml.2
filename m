Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1FMLyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:54:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1FMLyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:54:05 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=1ZhljathgHUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=4h7gygm8R-dtiupS-j4A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism
 for buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110613114904.GD10960@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172910.950101158@goodmis.org> <20110613101248.GC30962@elte.hu>
	 <1307965185.9218.53.camel@gandalf.stny.rr.com>
	 <20110613114904.GD10960@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:54:03 -0400
Message-ID: <1307966043.9218.63.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:49 +0200, Ingo Molnar wrote:

> > https://lkml.org/lkml/2011/3/17/366
> > 
> > I didn't really like adding another file to the debugfs system, and 
> > recommended the ioctl. It seemed like a nice "unix" fit. But if you 
> > want to go back to the Vaibhav's original method, which will stay 
> > in the frame of "human-parseable and scripted". We could do that.
> 
> Yes, i think so - the *only* point of the /debug/tracing/ muck is 
> that it's scriptable and human parseable. If Google wants to use it 
> for more than that then they should help us enhance the perf syscall 
> ABI for tracing ...

Hi Vaibhav,

Sorry for the spin around, but could you resubmit your original patch?

Thanks!

-- Steve


