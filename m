Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0LDBrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:47:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LDBrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:47:47 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=Tk12mGD_pOwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=EW12kSVajpMkpPKPvi0A:9 a=433WEHOuzhF4qYpZcMTz61wmgLkA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 06/15] ftrace: fix event alignment:
 module:module_request
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <1291421609-14665-7-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-7-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:47:45 -0500
Message-ID: <1291427265.16223.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ccing Li for an Acked-by. He wrote this event ]

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  include/trace/events/module.h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index c7bb2f0..8154f5f 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -98,14 +98,14 @@ TRACE_EVENT(module_request,
>  	TP_ARGS(name, wait, ip),
>  
>  	TP_STRUCT__entry(
> -		__field(	bool,		wait		)
>  		__field(	unsigned long,	ip		)
> +		__field(	bool,		wait		)
>  		__string(	name,		name		)
>  	),
>  
>  	TP_fast_assign(
> -		__entry->wait	= wait;
>  		__entry->ip	= ip;
> +		__entry->wait	= wait;
>  		__assign_str(name, name);
>  	),
>  
> @@ -119,4 +119,3 @@ TRACE_EVENT(module_request,
>  
>  /* This part must be outside protection */
>  #include <trace/define_trace.h>
> -


