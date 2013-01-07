Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3AGNyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:54:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3AGNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:54:05 -0500
X-Authority-Analysis: v=2.0 cv=IsacgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ozllkaMMHWsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=X0RNizWAH94A:10 a=57SyGIRnAAAA:8 a=hcjH-_9W1a0dVBmzCYkA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357566844.10284.84.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] tracing: Use sched_clock_cpu for trace_clock_global
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Fredereic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 07 Jan 2013 08:54:04 -0500
In-Reply-To: <87wqw3rfed.fsf@sejong.aot.lge.com>
References: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
	 <1356576585-28782-2-git-send-email-namhyung@kernel.org>
	 <87wqw3rfed.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 18:52 +0900, Namhyung Kim wrote:
> On Thu, 27 Dec 2012 11:49:45 +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> >
> > For systems have unstable sched_clock, all cpu_clock() does is enable/
> > disable local irq during call to sched_clock().  And for stable systems
> 
> Oops, I meant s/sched_clock/scheck_clock_cpu/.
> 

I'll queue this up for 3.9.

Thanks,

-- Steve


