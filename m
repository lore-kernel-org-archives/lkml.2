Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0LDBuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:50:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0LDBuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:50:24 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=Odz6ENB8xbgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=ncbP_KzaH4eYmmFnogEA:9 a=KkKeQnoY7sHGa8SJvcUbCUf3grsA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 08/15] ftrace: fix event alignment: mce:mce_record
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1291421609-14665-9-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-9-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:50:22 -0500
Message-ID: <1291427422.16223.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ccing Hidetoshi and Frederic for Acked-by's ]

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  include/trace/events/mce.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
> index 7eee778..4cbbcef 100644
> --- a/include/trace/events/mce.h
> +++ b/include/trace/events/mce.h
> @@ -17,36 +17,36 @@ TRACE_EVENT(mce_record,
>  	TP_STRUCT__entry(
>  		__field(	u64,		mcgcap		)
>  		__field(	u64,		mcgstatus	)
> -		__field(	u8,		bank		)
>  		__field(	u64,		status		)
>  		__field(	u64,		addr		)
>  		__field(	u64,		misc		)
>  		__field(	u64,		ip		)
> -		__field(	u8,		cs		)
>  		__field(	u64,		tsc		)
>  		__field(	u64,		walltime	)
>  		__field(	u32,		cpu		)
>  		__field(	u32,		cpuid		)
>  		__field(	u32,		apicid		)
>  		__field(	u32,		socketid	)
> +		__field(	u8,		cs		)
> +		__field(	u8,		bank		)
>  		__field(	u8,		cpuvendor	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->mcgcap		= m->mcgcap;
>  		__entry->mcgstatus	= m->mcgstatus;
> -		__entry->bank		= m->bank;
>  		__entry->status		= m->status;
>  		__entry->addr		= m->addr;
>  		__entry->misc		= m->misc;
>  		__entry->ip		= m->ip;
> -		__entry->cs		= m->cs;
>  		__entry->tsc		= m->tsc;
>  		__entry->walltime	= m->time;
>  		__entry->cpu		= m->extcpu;
>  		__entry->cpuid		= m->cpuid;
>  		__entry->apicid		= m->apicid;
>  		__entry->socketid	= m->socketid;
> +		__entry->cs		= m->cs;
> +		__entry->bank		= m->bank;
>  		__entry->cpuvendor	= m->cpuvendor;
>  	),
>  


