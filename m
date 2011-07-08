Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1GHPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:21:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1GHPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:21:16 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=kkYis8GwMtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9CFT8WX9HC8j9UVMNQUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [rfc] perf p4 events aliases
From: Steven Rostedt <rostedt@goodmis.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110708151307.GA6710@redhat.com>
References: <20110707152849.GV5485@sun>  <20110708151307.GA6710@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 08 Jul 2011 11:21:13 -0400
Message-ID: <1310138473.26417.231.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 11:13 -0400, Don Zickus wrote:
> On Thu, Jul 07, 2011 at 07:28:49PM +0400, Cyrill Gorcunov wrote:
> > Hi Don, if you have a chance could you please check if this
> > patch does a trick for nmi-watchdog and perf top? The idea
> > is to use aliases as being proposed early.
> 
> Hmm, didn't work for me.  The watchdog seems to work but 'perf top' showed
> nothing (even after 30 seconds).  I tried this on Linus's latest -tip and
> Ingo's perf/core -tip.  No luck.

Yeah I did the same. Without the patch, perf top works, with the patch I
get nothing.

-- Steve


