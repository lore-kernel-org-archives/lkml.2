Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1FMLn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:43:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1FMLn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:43:26 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=_6Fxket8JEMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=1upOvDf-zcInh4jiTO8A:9 a=rg3ENRvx5XjCINjEWwYA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 13/15] x86: Swap save_stack_trace_regs parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <20110613101823.GD30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172913.744922273@goodmis.org>  <20110613101823.GD30962@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:43:25 -0400
Message-ID: <1307965405.9218.57.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:18 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: yrl.pp-manager.tt@hitachi.com
> > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Namhyung Kim <namhyung@gmail.com>
> > Cc: linux-kernel@vger.kernel.org
> 
> That looks very messy:
> 
>  - there's duplicates
>  - the SOB is in the middle
>  - when there's a Link entry there's no need for a Cc: linux-kernel entry

Hmm, that was caused by my "do-git-am" script, that pulls in patches
from email. I added a new feature to add Cc's that were on the email but
not in the "Cc" list. I'll make sure it adds Cc's with other Cc's next
time.

BTW, I have it strip Cc's to me, do you want me to remove the Cc to you
as well? Or just keep the Cc to you in the change log (as I do now)?

As for the Cc to linux-kernel, I thought I fixed that. The script is
suppose to remove that Cc as well. I wonder why it missed it here? I
should have caught that on my final review. Sorry to miss it.

-- Steve


