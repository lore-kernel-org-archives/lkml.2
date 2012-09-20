Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2ITNc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:32:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2ITNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:32:56 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HXflXQAADJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ktVrgvLkdsoA:10 a=PZGWgwqiUP-TO0nCOyoA:9 a=PUjeQqilurYA:10 a=P-ezVrr_4_QA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348147973.13080.58.camel@gandalf.local.home>
Subject: Re: [PATCH 1/1] audit: Use a tracepoint for getname
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Paris <eparis@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Al Viro <viro@zeniv.linux.org.uk>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jlayton@redhat.com
Date: Thu, 20 Sep 2012 09:32:53 -0400
In-Reply-To: <20120920090545.465ca00d@redhat.com>
References: <20120919225659.GA11325@ghostprotocols.net>
	 <20120920090545.465ca00d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 09:05 -0400, Eric Paris wrote:

> I think we need to just use panic instead of audit_panic.  This early
> at boot userspace would not have been able to tell the kernel that
> audit_panic == panic nor would the box die later if userspace ask for
> that functionality.  Instead the box would run but audit would be
> broken, which customers who want audit_panic == panic would be most
> upset about.

Arnaldo, if you do convert it to panic, please denote that change in the
change log and give Erics explanation as well (quote him if needed ;-)

Thanks,

-- Steve


