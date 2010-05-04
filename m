Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab0EDUZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:25:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040Ab0EDUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:24:58 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=JYLeUmW3kWAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=UPW3Y8O6QF-58Loug2wA:9 a=IXQKGukrQijNiBU8Cx_wAjPzWEgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Make the documentation clear on trace_event
 boot option
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4B2F154C.2060503@cn.fujitsu.com>
References: <4B2F154C.2060503@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 16:24:54 -0400
Message-ID: <1273004694.22438.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going through old email, I came across this. Looks like it was never
applied, I'll pull it in. I think I was on vacation when this was
received, and got lost it the masses.

Sorry for the --very-- late response.

-- Steve


On Mon, 2009-12-21 at 14:27 +0800, Li Zefan wrote:
> Make it clear that event-list is a comma separated list of events.
> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  Documentation/trace/events.txt |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
> index 02ac6ed..778ddf3 100644
> --- a/Documentation/trace/events.txt
> +++ b/Documentation/trace/events.txt
> @@ -90,7 +90,8 @@ In order to facilitate early boot debugging, use boot option:
>  
>  	trace_event=[event-list]
>  
> -The format of this boot option is the same as described in section 2.1.
> +event-list is a comma separated list of events. See section 2.1 for event
> +format.
>  
>  3. Defining an event-enabled tracepoint
>  =======================================


