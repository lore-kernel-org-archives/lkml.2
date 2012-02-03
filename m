Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab2BCNkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:40:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2BCNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:40:36 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=jtGhZiCYFVg4XfqOlzsA:9 a=O8tZ53Qv79EBIG0Ne-0A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328276434.5882.141.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 08:40:34 -0500
In-Reply-To: <1327776209-4883-3-git-send-email-jolsa@redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-28 at 19:43 +0100, Jiri Olsa wrote:
>  
> +/*
> + * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
> + * set in the flags member.
> + *
> + * ENABLED - set/unset when ftrace_ops is registered/unregistered
> + * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           is part of the global tracers sharing the same filter
> + *           via set_ftrace_* debugfs files.
> + * DYNAMIC - set when ftrace_ops is registered to denote dynamically
> + *           allocated ftrace_ops which need special care
> + * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           could be controled by following calls:
> + *           ftrace_function_enable, ftrace_function_disable
> + */
>  enum {
>  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
>  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
>  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
>  };
>  

Nicely written :-)


-- Steve


