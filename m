Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2ISMlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:41:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2ISMlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:41:03 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=keDKqOnfphAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=sJv8MHQSONMA:10 a=vU69-6FlFOpodVL3cZIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348058460.13080.52.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Handle alloc_arg failure
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Wed, 19 Sep 2012 08:41:00 -0400
In-Reply-To: <1348057609.1644.9.camel@leonhard>
References: <87boh23epi.fsf@sejong.aot.lge.com>
	 <1348037109-17252-1-git-send-email-namhyung@kernel.org>
	 <20120919114258.GA16696@gmail.com> <1348057609.1644.9.camel@leonhard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 21:26 +0900, Namhyung Kim wrote:
> Hi Ingo,
> 

> Yeah, I agree.  But I wanted to add a bit more helpful (to developers)
> info - function name and line number - rather than just "not enough
> memory" message.  Maybe we could change do_warning to emit such info
> automatically.

But these only fail if you run out of memory for the tool. In that case,
I don't think it's that important which allocation failed.

-- Steve


