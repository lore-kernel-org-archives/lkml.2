Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1KCANZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:13:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1KCANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:13:24 -0400
X-Authority-Analysis: v=1.1 cv=QqHiGEe6yGvmA2Hj/+B5Qdh2oWFRI3gWtdRZxD5t9t4= c=1 sm=0 a=CMzmyBkqurIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pIBJB_62sv25t9g9biIA:9 a=nkZg9TzIzorapB0DLdEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320279201.4793.58.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 02 Nov 2011 20:13:21 -0400
In-Reply-To: <4EB1D0E2.6070909@gmail.com>
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
	 <1320275277.4793.54.camel@gandalf.stny.rr.com> <4EB1D0E2.6070909@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 17:23 -0600, David Ahern wrote:
> On 11/02/2011 05:07 PM, Steven Rostedt wrote:
> > This is a perf userspace bug, not a kernel one. Please fix the userspace
> > tool instead.
> > 
> > Note, the new version of libparsevent handles this case without issue.
> > Perf just needs to be updated.
> 
> I dare ask..... has any progress been made on that front? ie., with
> respect to lib names and locations within the tools dir.
> 

You dare too much... going into dangerous territory ;)


No, unfortunately, no progress has been made. I spoke a little with Ingo
in Prague, with Arjan too, and we still seem to disagree how to go
forward with this.

I may just punt and start pushing a separate library as it is today.
That is, a separate package, outside the kernel proper.

-- Steve


