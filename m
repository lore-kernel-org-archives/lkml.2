Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862Ab2ADFBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:01:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2ADFBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:01:44 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=iF1DTRsR_oHYW5j3V28A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325653301.12696.20.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 04 Jan 2012 00:01:41 -0500
In-Reply-To: <1325635922.12696.8.camel@gandalf.stny.rr.com>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 19:12 -0500, Steven Rostedt wrote:

> I should have tested this branch more. As I enabled BISECT_CHECK=1 in my
> ktest config, it boots both the bad commit and the good commit making
> sure the bad commit fails, and the good commit succeeds. The bad did
> fail, but so did the good commit, which was Linus's branch.
> 
> I booted it again just now, and it failed again.
> 
> I'll boot it a couple more times and maybe even recompile. Perhaps I
> didn't test Linus's branch correctly (checkout out the wrong branch?).

My mistake, I forgot to add the "minimum config" for booting the box.
When I did that, it booted fine. I kicked off the bisect again, and lets
see what happens.

-- Steve


