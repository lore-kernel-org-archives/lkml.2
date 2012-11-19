Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2KSMbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:31:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2KSMbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:31:51 -0500
Date: Mon, 19 Nov 2012 13:32:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jovi Zhang <bookjovi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uprobe: fix misleading log entry
Message-ID: <20121119123221.GA31544@redhat.com>
References: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com> <20121025141210.GA26929@redhat.com> <1353321774.6276.4.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353321774.6276.4.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Steven Rostedt wrote:
>
> On Thu, 2012-10-25 at 16:12 +0200, Oleg Nesterov wrote:
> > On 07/18, Jovi Zhang wrote:
> > >
> > > --- a/kernel/trace/trace_uprobe.c
> > > +++ b/kernel/trace/trace_uprobe.c
> > > @@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
> > >  	if (argv[0][0] == '-')
> > >  		is_delete = true;
> > >  	else if (argv[0][0] != 'p') {
> > > -		pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
> > > +		pr_info("Probe definition must be started with 'p' or '-'.\n");
> > >  		return -EINVAL;
> > >  	}
> >
> > Thanks, applied as 0d13ac96 (with Srikar's ack) in misc#uprobes/core
> >
> > Oleg.
>
> Hmm, this doesn't look like it ever got applied to mainline. Was it
> dropped?

I didn't send the pull request yet, will do today.

Oleg.

