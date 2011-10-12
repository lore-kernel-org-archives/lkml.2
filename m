Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1JLBpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 21:45:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36608 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980Ab1JLBpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 21:45:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18yAr90qGky5oK/8OifT9kDtqz+HlEVhLWniOXIPT
	AJ5DDknL05ESol
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <alpine.DEB.2.00.1110111821270.10060@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <20111010164339.GA8100@google.com> <1318342087.14615.5.camel@twins>
	 <1318352236.6194.22.camel@marge.simson.net>
	 <alpine.DEB.2.00.1110111821270.10060@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 03:45:37 +0200
Message-ID: <1318383937.6299.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 18:22 -0700, David Rientjes wrote:
> On Tue, 11 Oct 2011, Mike Galbraith wrote:
> 
> > I don't know of anything other than kthreadd where moving it here, or
> > over yonder matters one bit.
> > 
> 
> Clear PF_THREAD_BOUND for watchdog or migration kthreads and change their 
> affinity or move them into a cpuset where cpuset.cpus doesn't include the 
> cpu they are bound to and it'll be obvious.

Sure, I mean where Joe User can trip over an existing stumbling block.

	-Mike

