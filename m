Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2EKMCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:02:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2EKMCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:02:15 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=u_txzUxJlBoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=db_wQAYArh9AhR0307MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336737733.14207.252.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix a regression with enabling
 all events
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 11 May 2012 08:02:13 -0400
In-Reply-To: <1336691420.14207.246.camel@gandalf.stny.rr.com>
References: <1336691420.14207.246.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 19:10 -0400, Steven Rostedt wrote:
> Ingo,
> 
> I found this regression from the adding of function tracing to perf had
> a side effect of causing an error message to print, and potentially
> worse, the perf ->reg() function being called out of context.
> 

I did not add stable to this patch as the regression was introduced in
the 3.4 merge window and 3.3 is not affected.

-- Steve


