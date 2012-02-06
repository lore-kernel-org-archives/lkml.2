Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2BFTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:25:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2BFTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:25:56 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VjYjH05F8U0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0azM3ZO7AAAA:8 a=meVymXHHAAAA:8 a=Fisr9jk8P4HBRa_sR2IA:9 a=AxzrhC11Gez6_EST3MgA:7 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328556355.2200.22.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 06 Feb 2012 14:25:55 -0500
In-Reply-To: <alpine.LNX.2.00.1202042330210.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>
	  <1326661784.7642.140.camel@gandalf.stny.rr.com>
	  <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>
	  <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz>
	  <4F2C56D9.8010801@linux.intel.com>
	 <1328368512.5882.215.camel@gandalf.stny.rr.com>
	 <alpine.LNX.2.00.1202042330210.30244@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-04 at 23:31 +0100, Jesper Juhl wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Date: Sat, 4 Feb 2012 23:29:19 +0100
> Subject: [PATCH] Remove incorrect comment from include/trace/events/power.h
> 
> The code is not going to be removed, so remove the comment stating
> that it will be.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/trace/events/power.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index 1bcc2a8..5800eb8 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -65,7 +65,6 @@ TRACE_EVENT(machine_suspend,
>  	TP_printk("state=%lu", (unsigned long)__entry->state)
>  );
>  
> -/* This code will be removed after deprecation time exceeded (2.6.41) */
>  #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
>  
>  /*
> -- 
> 1.7.9
> 
> 
> 


