Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1FCO06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:26:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab1FCO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:26:57 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=zNdHVLF5wXUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xANjiYt0Qht4UJcB-_8A:9 a=gDFztFsx0IMiradLHWoA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/5] tracing, function, graph: Fixies for field display
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
References: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 10:26:55 -0400
Message-ID: <1307111215.3667.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 16:19 +0200, Jiri Olsa wrote:
> hi,
> 
> this patchset contains some fixies of trace output for
> function and function_graph tracers.
> 
> attached patches:
> 1/5 tracing, function_graph: Remove dependency of abstime and duration fields on latency
> 2/5 tracing, function_graph: Merge overhead and duration display functions
> 3/5 tracing, function: Fix trace header to follow context-info option
> 4/5 tracing, function_graph: Remove lock-depth from latency trace
> 5/5 tracing, function_graph: Add context-info support for function_graph tracer

Hi Jiri,

Thanks for these patches. But could you change the change logs to show
the problems that you see. Just a description does not express what is
really wrong. Basically add a:

This is what it looked like before:

....


This is what it looks like now:

....


That way it is obvious what the patches do. I'll test these anyway to
get a before and after, but it is helpful to see it in the change log.

Thanks,

-- Steve


