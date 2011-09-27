Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1I0UNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:13:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1I0UNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:13:20 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=nYxVPzDsqTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=pGLkceISAAAA:8 a=DfNHnWVPAAAA:8 a=meVymXHHAAAA:8 a=HEx84UgoRPTLIyFP7V4A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing
 rpm_* functions
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tom.leiming@gmail.com, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
Date: Tue, 27 Sep 2011 16:13:16 -0400
In-Reply-To: <201109272206.34176.rjw@sisk.pl>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com>
	 <1317118338-4040-2-git-send-email-tom.leiming@gmail.com>
	 <201109272206.34176.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317154398.26514.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 22:06 +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 27, 2011, tom.leiming@gmail.com wrote:
> > From: Ming Lei <ming.lei@canonical.com>
> > 
> > This patch introduces 3 trace points to prepare for tracing
> > rpm_idle/rpm_suspend/rpm_resume functions, so we can use these
> > trace points to replace the current dev_dbg().
> > 
> > Cc: Steven Rostedt rostedt@goodmis.org
> > Signed-off-by: Ming Lei <ming.lei@canonical.com>
> > ---
> > v1: takes Steven's suggestions
> > 	- use __assign_str to dump device name to trace buffer
> > 	- pass _THIS_IP_ to trace_rpm_return_int
> 
> Steven, do the patches look good to you now?

Yep,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


