Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1EFV5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:57:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1EFV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:57:12 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D3GVLUZHKheKooPcGfoA:9 a=5ZknfV13W-MvGBpuQVoA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4DC4683C.6070208@linux.intel.com>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <4DC4683C.6070208@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 May 2011 17:57:09 -0400
Message-ID: <1304719029.25414.2544.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 14:29 -0700, Arjan van de Ven wrote:
> On 5/6/2011 1:51 PM, Linus Torvalds wrote:
> >
> > You could help fix the tools, and try to avoid the compatibility
> > issues that way. There aren't that many of them.
> 
> once we have a usable library for these (and by usable, I mean that, eg 
> something that someone like Fedora or Ubuntu can package and install)
> I will be more than happy to use it in PowerTOP. Today that does not exist.
> 
> If such library becomes reality soon, then I'll adjust PowerTOP soon as 
> well, and we can remove the padding some time after that even if that is 
> really desired.
> But we're talking 4 bytes here....

I'll work on getting the library out to distros. The 4 bytes is not the
issue, it's the implication that the header is fixed in stone. As we
want to get rid of the pid, and flags as well. Making this in stone just
killed any more progress that ftrace/perf can do in becoming a more
robust tracer.

-- Steve



