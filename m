Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543Ab2EPTjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:39:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2EPTjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:39:15 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=yiqiDAmUTpBPOHv5gO0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337197154.6724.68.camel@gandalf.stny.rr.com>
Subject: Re: Perf record format portability
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 15:39:14 -0400
In-Reply-To: <1337196743.6724.66.camel@gandalf.stny.rr.com>
References: <4FB275EB.5050904@linaro.org>
	 <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>
	 <20120516145927.GC7864@infradead.org>
	 <1337187503.6724.50.camel@gandalf.stny.rr.com>
	 <20120516174825.GA11516@m.brq.redhat.com>
	 <1337196743.6724.66.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 15:32 -0400, Steven Rostedt wrote:
> On Wed, 2012-05-16 at 19:48 +0200, Jiri Olsa wrote:
> 
> > for ppc64(record) vs x86_64(report) I got following report on latest tip:
> > 
> > [jolsa@dhcp-26-214 test]$ ../perf report > report.target
> > Endianness of raw data not corrected!
> > Warning:
> > 718 samples with id not present in the header
> > Warning:
> > The perf.data file has no samples!
> > 

What does perf script give you. It looks like Frederic took my code for
this when he ported the original parse-events over to perf. I see the
setup of these variables in tools/perf/util/trace-event-read.c

If you run 'perf script' on x86 from a ppc perf.dat file, do you still
get the same errors?

-- Steve


