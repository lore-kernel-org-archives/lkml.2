Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1JORGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:06:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41973 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1JORGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:06:34 -0400
Date: Sat, 15 Oct 2011 19:04:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20111015170452.GD29782@elte.hu>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
 <20111015145946.GB9516@elte.hu>
 <4E99BC44.40400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99BC44.40400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/15/2011 08:59 AM, Ingo Molnar wrote:
> > Btw., i noticed another weirdness - sometimes after startup i get 
> > this message:
> > 
> > /lib64/libc-2.14.90.so was updated, restart the long running apps that use it!                          
> > 
> > but it was not updated recently:
> > 
> >  earth5:~/tip/tools/perf> ll /lib64/libc-2.14.90.so
> >  -rwxr-xr-x 1 root root 2062920 Sep 28 15:11 /lib64/libc-2.14.90.so
> >  earth5:~/tip/tools/perf> date
> >  Sat Oct 15 16:59:04 CEST 2011
> >  earth5:~/tip/tools/perf> uptime
> >   16:59:08 up 19 days, 21:35, 11 users,  load average: 7.77, 7.48, 3.81
> 
> I got the impression that comment was relative to when the 
> processes were started versus prelink touching it. In your case the 
> mod time of libc is after the uptime of the box.

Ok, that makes sense. Do we report this in perf report output as 
well?

Thanks,

	Ingo
