Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2BJOpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:45:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2BJOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:45:22 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eSfxnIkts4oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=BhM_4Fa3dstg1yn3x2cA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328885120.8273.7.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 10 Feb 2012 09:45:20 -0500
In-Reply-To: <1328880444.8273.3.camel@gandalf.stny.rr.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
	 <1328880444.8273.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 08:27 -0500, Steven Rostedt wrote:
> On Tue, 2012-02-07 at 20:44 +0100, Jiri Olsa wrote:
> > hi,
> > here's another version of perf support for function trace
> > with filter. 
> 
> OK, I've applied all of these and I'm now going to run them through my
> test suite before sending them to Ingo. I'll let you know if anything
> goes wrong.

OK, I build booted and installed a kernel with your patches. I also
installed the latest perf code from linus/master. Then I ran the
following:

# perf record -e ftrace:function ls

and then ran

# perf report

It went into an infinite loop of "Processing time ordered events".

Is this expected?

Although perf script works fine.

-- Steve


