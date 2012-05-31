Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2EaCNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:13:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab2EaCNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:13:52 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Qk0tmqCOqu8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=NIxnuYx9hz4iEgmGTZ4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338430431.13348.318.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5] (for 3.5)[GIT PULL] ftrace: Fix bug with function
 tracing and lockdep
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 30 May 2012 22:13:51 -0400
In-Reply-To: <20120531012829.160060586@goodmis.org>
References: <20120531012829.160060586@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> Ingo,
> 

> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 1f9f5e93a9ab9cdf2504a25c24f3f8715c4ba785
> 

Oh, I forgot to add in my announcement subject, that this is for 3.5, as
this bug came in during this merge window, with the exception of patch 3
which fixes a bug introduced in 3.3.

-- Steve


