Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2LHCDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:03:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab2LHCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:03:14 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jjup16wEm2MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9ke5-BzDvmcA:10 a=GvQkQWPkAAAA:8 a=HC9kQECEAAAA:8 a=qmVyt8qcAAAA:8 a=NFeWiZhyXaqSrJelvsIA:9 a=PUjeQqilurYA:10 a=ScRQMLrRlwEA:10 a=Wwjp7rKQgkIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354932192.17101.115.camel@gandalf.local.home>
Subject: Re: [PATCH v4 7/9] trace: use this_cpu_ptr per-cpu helper
From: Steven Rostedt <rostedt@goodmis.org>
To: Shan Wei <shanwei88@gmail.com>
Cc: fweisbec@gmail.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, cl@linux-foundation.org,
        Tejun Heo <htejun@gmail.com>
Date: Fri, 07 Dec 2012 21:03:12 -0500
In-Reply-To: <50B85456.9040807@gmail.com>
References: <50A1A800.3020102@gmail.com> <50A5FA84.8080106@gmail.com>
	 <50B85456.9040807@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 14:38 +0800, Shan Wei wrote:
> Shan Wei said, at 2012/11/16 16:34:
> > Shan Wei said, at 2012/11/13 9:53:
> >> From: Shan Wei <davidshan@tencent.com>
> >>
> >> typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
> >> But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
> >> As well-known, the value of &buffer is equal to &buffer[0].
> >> so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast. 
> >>
> >> Signed-off-by: Shan Wei <davidshan@tencent.com>
> > 
> > Steven Rostedt,  would you like to pick it up to your tree?
> 
> ping......................

Sorry for the late reply. I've been hacking on other things and my queue
of stuff for tip still hasn't been pulled yet. I'll pull this into my
tree, and see if I can get it in by the merge window. If the merge
window opens this weekend, I'll add this to my 3.9 queue.

-- Steve


