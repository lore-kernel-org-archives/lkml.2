Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0JOQSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:18:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0JOQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:18:05 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=nFyw1t5h3Z8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2KOJt5I1aKuWXccGadUA:9 a=qsHKzknyuAMpx34wwq50Drp9-iUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] ftrace: Rename config option
 HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101015094119.GA21002@elte.hu>
References: <1287114319.23682.34.camel@gandalf.stny.rr.com>
	 <20101015041307.GA31764@elte.hu> <20101015073836.GA6870@elte.hu>
	 <20101015094119.GA21002@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 12:18:02 -0400
Message-ID: <1287159482.23682.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 11:41 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, a recent tracing change causes this new warning on latest -tip:
> 
> It appears it has been there for a longer time. So not caused by a 
> recent commit - but it's a real warning nevertheless.

Ah, did you do a make clean after removing the recent commits and trying
again? If not, the ftrace.o file will still contain the "mcount"
reference and still cause the same issue.

-- Steve


