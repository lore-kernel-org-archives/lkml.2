Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2AOVJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:09:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2AOVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:09:46 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VjYjH05F8U0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0azM3ZO7AAAA:8 a=TfwP1w2IsgargYKb_ZkA:9 a=r79iQ7dOv7dkGlr-QYgA:7 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=qxu0pTVj6Xv0V5SN:21 a=5Ndz7OfxorIXNviJ:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326661784.7642.140.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 15 Jan 2012 16:09:44 -0500
In-Reply-To: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 21:48 +0100, Jesper Juhl wrote:
> What was originally going to be 2.6.41 became 3.1 .
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  include/trace/events/power.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index 1bcc2a8..b262699 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -65,7 +65,7 @@ TRACE_EVENT(machine_suspend,
>  	TP_printk("state=%lu", (unsigned long)__entry->state)
>  );
>  
> -/* This code will be removed after deprecation time exceeded (2.6.41) */
> +/* This code will be removed after deprecation time exceeded (3.1) */

Shouldn't the real fix be to remove this code? What's the use of
changing the version number that this code will be removed from, when
the change won't get in until after the version that this code should
have been removed?

This is like updating 2014 calendars to say the world will end in 2012.

-- Steve

>  #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
>  
>  /*
> -- 
> 1.7.8.3
> 
> 


