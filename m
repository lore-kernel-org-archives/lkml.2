Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2KSKm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:42:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2KSKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:42:56 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RerB04ERD-kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=va1J9FDBKhAA:10 a=MhDRbb3HAAAA:8 a=JWOaUvblDZpT5lMdVu0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353321774.6276.4.camel@gandalf.local.home>
Subject: Re: [PATCH] uprobe: fix misleading log entry
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jovi Zhang <bookjovi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 19 Nov 2012 05:42:54 -0500
In-Reply-To: <20121025141210.GA26929@redhat.com>
References: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
	 <20121025141210.GA26929@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 16:12 +0200, Oleg Nesterov wrote:
> On 07/18, Jovi Zhang wrote:
> >
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
> >  	if (argv[0][0] == '-')
> >  		is_delete = true;
> >  	else if (argv[0][0] != 'p') {
> > -		pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
> > +		pr_info("Probe definition must be started with 'p' or '-'.\n");
> >  		return -EINVAL;
> >  	}
> 
> Thanks, applied as 0d13ac96 (with Srikar's ack) in misc#uprobes/core
> 
> Oleg.

Hmm, this doesn't look like it ever got applied to mainline. Was it
dropped?

-- Steve


