Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2LNRIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:08:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2LNRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:08:34 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O7yW5i6_SjkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=apWNB6VHehcA:10 a=sz2bESrhxUycLBONxAAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355504913.17101.399.camel@gandalf.local.home>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 14 Dec 2012 12:08:33 -0500
In-Reply-To: <50C14F5A.50807@hitachi.com>
References: <20121017025608.2627.87497.stgit@falsita>
			 <20121017025619.2627.96794.stgit@falsita>
		 <1353030384.9391.19.camel@gandalf.local.home>
		 <50B84822.6010409@hitachi.com>
	 <1354285026.6276.157.camel@gandalf.local.home> <50C14F5A.50807@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 11:07 +0900, Hiraku Toyooka wrote:
> Hi, Steven,
> 
> (2012/11/30 23:17), Steven Rostedt wrote:
> [snip]
>  >
>  > Actually, I would have:
>  >
>  >   status\input |     0      |     1      |    else    |
>  >  --------------+------------+------------+------------+
>  >  not allocated |(do nothing)| alloc+swap |   EINVAL   |
>  >  --------------+------------+------------+------------+
>  >    allocated   |    free    |   swap     |   clear    |
>  >  --------------+------------+------------+------------+
>  >
>  > Perhaps we don't need to do the clear on swap, just let the trace
>  > continue where it left off? But in case we should swap...
>  >
> 
> I think we don't need the clear on swap too.
> I'll update my patches like this table.
> 
>  > There's a fast way to clear the tracer. Look at what the wakeup tracer
>  > does. We can make that generic. If you want, I can write that code up
>  > too. Hmm, maybe I'll do that, as it will speed things up for
>  > everyone :-)
>  >
> 

BTW, any update on this? I really like to get this into 3.9.

Thanks!

-- Steve


