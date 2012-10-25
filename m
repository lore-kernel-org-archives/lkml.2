Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2JYOOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:14:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010Ab2JYOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:04 -0400
Date: Thu, 25 Oct 2012 16:12:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uprobe: fix misleading log entry
Message-ID: <20121025141210.GA26929@redhat.com>
References: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Jovi Zhang wrote:
>
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
>  	if (argv[0][0] == '-')
>  		is_delete = true;
>  	else if (argv[0][0] != 'p') {
> -		pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
> +		pr_info("Probe definition must be started with 'p' or '-'.\n");
>  		return -EINVAL;
>  	}

Thanks, applied as 0d13ac96 (with Srikar's ack) in misc#uprobes/core

Oleg.

