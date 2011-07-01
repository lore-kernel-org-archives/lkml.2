Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1GANLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:11:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab1GANLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:11:16 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=d-8w2qbBBTkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NPU8Du3l_ywT4lultZkA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/16 v2] [GIT PULL] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <20110701124455.GD12605@elte.hu>
References: <20110615134841.767565350@goodmis.org>
	 <20110616140050.GA4822@elte.hu>
	 <1309290496.26417.16.camel@gandalf.stny.rr.com>
	 <20110701124455.GD12605@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 09:11:13 -0400
Message-ID: <1309525873.26417.141.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 14:44 +0200, Ingo Molnar wrote:

> > Hi Ingo,
> > 
> > Was there an issue with this pull request? I don't see it in tip. I 
> > was about to add a fix for Thomas and noticed that this pull wasn't 
> > in.
> 
> Hm, the problem appears to be that your tip/perf/core-2 branch is on 
> 0ef5bf1cd3bd - which does not match the bits you advertised in:
> 
>     Head SHA1: 1fd8df2c3970c9e7e4e262354154ee39e58bdd7c

Ah, you're right! I'm glad I advertise that. I didn't notice that my
push failed due to not being a fast forward. I just pushed now, it may
take a bit to hit the mirrors.

Thanks,

Steve


