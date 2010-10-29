Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab0J2D5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:57:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab0J2D5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:57:03 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=QDC8QjlfTZkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NZQaldp3rW1UCdqTPLIA:9 a=tvveKVTekCw1Lxhqxe8vhrMoBT0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        autotest@test.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <20101029034142.GA12125@suse.de>
References: <1288294944.18238.346.camel@gandalf.stny.rr.com>
	 <20101029002740.GA7688@suse.de>
	 <1288321849.18238.395.camel@gandalf.stny.rr.com>
	 <20101029034142.GA12125@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 23:56:59 -0400
Message-ID: <1288324619.18238.414.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 20:41 -0700, Greg KH wrote:
> > 
> > Should I try to get this into 2.6.37?  Since it is a stand alone tool, I
> > can hardly expect that it would break anything else.
> 
> I don't see why not, but perhaps you might want to wait for people to
> test it a bit?  Then get it into .38?

That's sorta the catch-22. We want testers before pushing it into
mainline, but if it is in mainline we get more testers :-)

I'm not sure it makes a difference now if it goes in or if it does not.
Because it would reside in tools as a helper program, and will not
affect the quality of the kernel whether it's in the kernel tree or not.
Although, I could argue that it may help the quality of the kernel if it
is in the kernel tree because it may have more people testing the
kernel.


One thing I worry about adding it to the tools directory. I could
imagine someone running the tool from the tools directly from the build
source that they are testing. If they do a bisect, a bisect may remove
the tools directory while its running. That would be an interesting
test ;-)

-- Steve


