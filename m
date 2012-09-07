Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab2IGOiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:38:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2IGOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:38:07 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RYtxJhnLXCEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Mp8wgFcg3vgA:10 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=cLG42g3Jn4-vpSt1Xj0A:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=Z2_L4aV3hKJ0eztf:21 a=GbYhS7mhAP0D33hk:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347028684.8178.5.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] tools lib traceevent: Get rid of die() from
 pretty_print()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 07 Sep 2012 10:38:04 -0400
In-Reply-To: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:49 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There are three cases that call die() in the pretty_print.
> 
>  1. insufficient number of argument: cannot proceed anymore.
>  2. too long format conversion specifier: truncate and proceed.
>  3. bad size specifier in format string: skip and proceed.
> 
> For all cases, convert die to do_warning, mark the event as
> EVENT_FL_FAILED and print error message at the last.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Thanks Namyung!

Arnaldo,

Please add my "Acked-by: Steven Rostedt <rostedt@goodmis.org>" to all
three of these patches.

-- Steve


