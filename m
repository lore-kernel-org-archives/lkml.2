Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1LSTWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:22:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1LSTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:22:18 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=tVazo0yrEIsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=KzvNuwGDsbWFFCAyzVcA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324322536.5916.37.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 07/10] ftrace: Change filter/notrace set functions to
 return exit code
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 19 Dec 2011 14:22:16 -0500
In-Reply-To: <1323105776-26961-8-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-8-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> Currently the ftrace_set_filter and ftrace_set_notrace functions
> do not return any return code. So there's no way for ftrace_ops
> user to tell wether the filter was correctly applied.
> 
> The set_ftrace_filter interface returns error in case the filter
> did not match:
> 
>   # echo krava > set_ftrace_filter
>   bash: echo: write error: Invalid argument
> 
> Changing both ftrace_set_filter and ftrace_set_notrace functions
> to return zero if the filter was applied correctly or -E* values
> in case of error.

This looks like a proper fix. Move this to the front of the patch set,
as this and patch 1 can go into ftrace now as fixes.

-- Steve

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>


