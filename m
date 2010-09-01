Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0IAOze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 10:55:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab0IAOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 10:55:32 -0400
X-Authority-Analysis: v=1.1 cv=jsU1gHzFqI0vjyg35dbbhFRlpVAv39iqdMS5PbCl9Js= c=1 sm=0 a=V1fT4SIjhY4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KdpMznlvsJPZ3LGGSwQA:9 a=jmjUV8oJNDLSg9Tnuqe-7CqAaOgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 5/9] perf: Move trace stuff into tools/lib/trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
In-Reply-To: <20100901081013.GA23512@aftab>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
	 <1281104713-23141-6-git-send-email-bp@amd64.org>
	 <1283300144.1377.864.camel@gandalf.stny.rr.com>
	 <20100901081013.GA23512@aftab>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Sep 2010 10:55:30 -0400
Message-ID: <1283352930.2356.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 10:10 +0200, Borislav Petkov wrote:

> > I'll merge this patch into my tree, and that should make it easier for
> > you.
> 
> Yeah, that's cool. FYI, Arnaldo wanted to have that toplevel-Makefile
> thing too (tools/Makefile) so there might be some conflicts depending on
> how far he is.

OK, thanks for letting me know. I'll get into contact with Arnaldo and
sort it out.

-- Steve


