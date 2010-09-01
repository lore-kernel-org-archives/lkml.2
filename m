Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IAAPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:15:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab0IAAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:15:52 -0400
X-Authority-Analysis: v=1.1 cv=F68j8apdn+AYvba2s2WjKYIAmW276Pjvg9wPu/ZwFig= c=1 sm=0 a=V1fT4SIjhY4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zd2uoN0lAAAA:8 a=gRooxsz4id91kcs3b_IA:9 a=g0moWKwSXQweRG1jcJ4A:7 a=oH3fOd7RCU3rbTF6ewNSoM-Ayv8A:4 a=PUjeQqilurYA:10 a=wu_e27o_rKQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 5/9] perf: Move trace stuff into tools/lib/trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: acme@infradead.org, fweisbec@gmail.com, mingo@elte.hu,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <1281104713-23141-6-git-send-email-bp@amd64.org>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
	 <1281104713-23141-6-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 20:15:44 -0400
Message-ID: <1283300144.1377.864.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 16:25 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Move tracing stuff into tools/lib/trace and rewire it back into perf.
> Add a top-level Makefile which selects between targets depending
> on the tool we want to build.
> 
> Also, add a Makefile.lib for common facilities used by all the
> Makefiles. While at it, make sure objects output directory using O=
> exists.
> 
> Finally, rename trace/util.h to trace/trace-util.h so as not to
> conflict
> with perf's util.h.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> --- 


I'll merge this patch into my tree, and that should make it easier for
you.

-- Steve


