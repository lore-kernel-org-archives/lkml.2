Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab0J0DYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:24:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752702Ab0J0DYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:24:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/trvdZTbrtbv41OQ8aUXmyfGoFpIT6upeQhD5i+J
	mpVk9JNJ+xe7ZW
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
From: Mike Galbraith <efault@gmx.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20101026135808.GB1672@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
	 <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
Content-Type: text/plain
Date: Wed, 27 Oct 2010 05:24:36 +0200
Message-Id: <1288149876.7296.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 15:58 +0200, Markus Trippelsdorf wrote:

> > > Initializing cgroup subsys cpu
> > > Linux version 2.6.36-05618-gb18cae4-dirty (markus@arch.trippelsdorf.de) (gcc version 4.5.1 (GCC) ) #41 SMP PREEMPT Tue Oct 26 06:51:47 CEST 2010
> > 
> >  ...-dirty means you have some changes ontop of b18cae4. What are those?
> 
> The SCHED_AUTOGROUP patches from Mike Galbraith.

Turns out that patch is still racy btw.  Very hard to trigger, but you
should remove it for safety and test result integrity anyway.

	-Mike

