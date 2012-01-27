Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2A0RVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:21:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2A0RVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:21:42 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=qcpVTxH1PgtfdFhMsAsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327684899.22710.115.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 27 Jan 2012 12:21:39 -0500
In-Reply-To: <20120127165416.GD10601@m.brq.redhat.com>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
	 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
	 <20120120170232.GF18056@somewhere>
	 <1327533221.22710.74.camel@gandalf.stny.rr.com>
	 <20120126023726.GI20878@somewhere> <20120127103714.GA6294@m.brq.redhat.com>
	 <20120127164045.GA3391@somewhere> <20120127165416.GD10601@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 17:54 +0100, Jiri Olsa wrote:

> yay.. ok :) so this one is triggered only if there's CONFIG_DEBUG_PREEMPT
> option enabled.. seems to me it'd better to keep the implicit check anyway.

If the per_cpu pointer usage already warns if preemption is not
disabled, then we don't need the extra check. I think I was the one to
recommend adding it, but if the warning is already there, I don't think
it is necessary. You can still keep a comment, and even say, the per_cpu
pointer usage will complain when CONFIG_DEBUG_PREEMPT is enabled, if
this is called without preemption disabled.

-- Steve


