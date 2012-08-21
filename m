Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2HUODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:03:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2HUODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:03:46 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=07ZCQtT27sEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZRzJ3tYFNvQA:10 a=meVymXHHAAAA:8 a=w_O_85iTpMI237hb1kEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345557825.5069.4.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Aug 2012 10:03:45 -0400
In-Reply-To: <20120821135016.GA23899@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <1345545050.23018.95.camel@twins>
	 <20120821131136.GC21432@aftab.osrc.amd.com>
	 <1345556475.5069.3.camel@gandalf.local.home>
	 <20120821135016.GA23899@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 15:50 +0200, Borislav Petkov wrote:
> On Tue, Aug 21, 2012 at 09:41:15AM -0400, Steven Rostedt wrote:
> > Definitely the second one. The first one is just ugly. The second is
> > more in line to the tracing directories too:
> >
> > /debug/tracing/per_cpu/cpu0/...
> 
> Maybe I can reuse your code and add
> 
> /debug/tracing/per_cpu/cpu0/persistent/<event>
> 
> ?
> 
> It is basically debugfs handling, right? Or are you reworking that
> too?
> 

Anything global wont be modified. IOW, tools wont break :-)

-- Steve


