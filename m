Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2JLEtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:49:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41871 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab2JLEtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:49:33 -0400
Date: Fri, 12 Oct 2012 10:20:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jovi Zhang <bookjovi@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uprobe: fix misleading log entry
Message-ID: <20121012045044.GA31442@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
 <20120718092252.GD5006@linux.vnet.ibm.com>
 <CACV3sbKzGHP6UeOb7UYEUUbDp2P5KUaPCDD52-K9rmMGjVVV=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACV3sbKzGHP6UeOb7UYEUUbDp2P5KUaPCDD52-K9rmMGjVVV=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12101204-5806-0000-0000-00001A95AC47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 18, 2012 at 5:22 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > * Jovi Zhang <bookjovi@gmail.com> [2012-07-18 11:08:42]:
> >
> >> From 68232ef2decae95b807f2f3763e8ea99c1a3b2ae Mon Sep 17 00:00:00 2001
> >> From: Jovi Zhang <bookjovi@gmail.com>
> >> Date: Wed, 18 Jul 2012 17:51:26 +0800
> >> Subject: [PATCH] uprobe: fix misleading log entry
> >>
> >> There don't have any 'r' prefix in uprobe event naming, remove it.
> >>
> >> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> >> ---
> >>  kernel/trace/trace_uprobe.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> >> index cf382de..852a584 100644
> >> --- a/kernel/trace/trace_uprobe.c
> >> +++ b/kernel/trace/trace_uprobe.c
> >> @@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
> >>       if (argv[0][0] == '-')
> >>               is_delete = true;
> >>       else if (argv[0][0] != 'p') {
> >> -             pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
> >> +             pr_info("Probe definition must be started with 'p' or '-'.\n");
> >>               return -EINVAL;
> >>       }
> >>
> >
> > Yes, uprobes doesnt support return probes. So we should not have
> > mentioned about r.
> >
> > Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> >
> 

Ingo/Andrew

Can you please pick this.


-- 
Thanks and Regards
Srikar

