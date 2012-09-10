Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2IJOkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:40:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2IJOkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:40:05 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JBLNcV8zRgkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=B2NTZjWQ9qwA:10 a=O3GDwc5Q9ozlfESNd9EA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347288002.10751.14.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] perf: Enable function tracing for perf core
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 10 Sep 2012 10:40:02 -0400
In-Reply-To: <87627oa9di.fsf@kernel.org>
References: <20120908115515.211175517@goodmis.org>
	 <20120908115640.032328533@goodmis.org> <87627oa9di.fsf@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 23:15 +0900, Namhyung Kim wrote:
> Hi Steve,
> 
> It seems you missed From: line?
> 
> Thanks,
> Namhyung
> 

Someone already pointed this out to me. The git pull is fine as all the
authorship is correct.

I recently reinstalled my machine and not all my scripts were in place.
My scripts does a git format-patch, and makes a quilt queue out of them.
But quilt doesn't like the headers of the files git makes, and my
scripts call another script that adds the proper 'From' lines for quilt.

That script didn't get installed properly, and quilt chopped off the git
'From' lines when it sent it out.

But don't worry, if you look at the git branch that I asked to pull,
everything is set up properly. I've also fixed my scripts so that the
next time it will add the proper From lines.

Just don't pull the patches directly from the mailing list ;-)

-- Steve


