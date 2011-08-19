Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HSCBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 22:01:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HSCBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 22:01:18 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=5jgD01Iq_tUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KyhVQI99KrkiXTnCYnAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/4 v2] [GIT PULL][v3.2] x86: Consolidate 32 and 64 bit
 thread_info
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <4E3CA12D.1030408@zytor.com>
References: <20110806011102.721109343@goodmis.org>
	 <4E3CA12D.1030408@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 22:01:15 -0400
Message-ID: <1313719275.15704.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 19:04 -0700, H. Peter Anvin wrote:
> On 08/05/2011 06:11 PM, Steven Rostedt wrote:
> > 
> > Thomas, Ingo, and Peter(s),
> > 
> > On IRC, Peter Zijlstra mentioned to me the difference between
> > 32bit and 64bit x86 on how thread_info is handled with interrupts.
> > I mentioned that they should be more the same, and Peter agreed.
> > 
> > I decided to do so, and ended up with the following patches.
> > I marked this for v3.2 as it should be tested a bit before going into
> > mainline. I've ran several configs on it, but more testing should be done.
> > 
> > Some of the patches are clean ups, but the main ones are patch 3 and 4
> > that do the work to convert 32bit of thread_info to be more like
> > the 64bit.
> > 
> 
> Hi Steven,
> 
> I'd like to wait until the merge window is over with pulling in 3.2
> material ... nothing personal or technical, just to simplify management.
> 
> 	-hpa
> 

Ping?

-- Steve


