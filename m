Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2K1Bul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:50:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2K1Buk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:50:40 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=QxCMnIhv2_UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rlcpCz2pQhMA:10 a=-Zfs-bak-s9zmbhkPDMA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354067438.6276.92.camel@gandalf.local.home>
Subject: Re: [PATCH] context_tracking: New context tracking susbsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Date: Tue, 27 Nov 2012 20:50:38 -0500
In-Reply-To: <20121128005942.GV2474@linux.vnet.ibm.com>
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
	 <20121128005942.GV2474@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 16:59 -0800, Paul E. McKenney wrote:
> On Tue, Nov 27, 2012 at 07:33:25PM +0100, Frederic Weisbecker wrote:
> > Create a new subsystem that probes on kernel boundaries
> > to keep track of the transitions between level contexts
> > with two basic initial contexts: user or kernel.
> > 
> > This is an abstraction of some RCU code that use such tracking
> > to implement its userspace extended quiescent state.
> > 
> > We need to pull this up from RCU into this new level of indirection
> > because this tracking is also going to be used to implement an "on
> > demand" generic virtual cputime accounting. A necessary step to
> > shutdown the tick while still accounting the cputime.
> 
> I have queued this, and if it passes tests and inspection will try
> pushing it for 3.8.
> 

You can add my Reviewed-by: Steven Rostedt <rostedt@goodmis.org> if you
like.

-- Steve


