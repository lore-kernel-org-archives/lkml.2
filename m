Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0IAOy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 10:54:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab0IAOy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 10:54:27 -0400
X-Authority-Analysis: v=1.1 cv=+ajm3tfMPLNCEbkepGq+oOGV0QVCaQQ0JBMd0bjnRvg= c=1 sm=0 a=jgjcqcETl78A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jkXEy8quUUDdGudbazoA:9 a=t_ImX8LMJo7OqM4PUrYA:7 a=iyB2eepISl_X2lgT5Mwug6EPpDsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 4/9] mce: Add persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        acme@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <20100901061402.GA22874@elte.hu>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
	 <1281104713-23141-5-git-send-email-bp@amd64.org>
	 <1281106636.1947.710.camel@laptop>
	 <1283300000.1377.863.camel@gandalf.stny.rr.com>
	 <20100901061402.GA22874@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Sep 2010 10:54:25 -0400
Message-ID: <1283352865.2356.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 08:14 +0200, Ingo Molnar wrote:

> More generally i agree with you that better modularization helps - a 
> nice improvement in this area would be to do a kernel/perf_event/ 
> splitup: i.e. split kernel/perf_event.c (which is getting a tad big) 
> into:
> 
>   kernel/events/output.c
>   kernel/events/trace.c
>   kernel/events/core.c
>   kernel/events/syscall.c
>   kernel/events/persistent.c
> 
> Maybe even move hw_breakpoint.c there, etc. There's already various 
> wrappers in perf_event.c that could be split out of the core code to 
> increase modularity. Later on we could have a sysfs.c, etc.
> 
> Any taker for such a massive restructuring? :)

I'm willing to help out. Just need to get past all the confs I seemed to
be going to lately. I feel I'm traveling once a month. Of course my
recent vacations did not help any ;-)

-- Steve


