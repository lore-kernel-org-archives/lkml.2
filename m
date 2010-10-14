Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0JNXgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:36:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36550 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0JNXgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:36:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Oct 2010 08:30:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, bharata@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed
 their local quota
Message-Id: <20101015083032.c9a1b2aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287052904.29097.191.camel@twins>
References: <20101012074910.GA9893@in.ibm.com>
	<20101012075202.GD9893@in.ibm.com>
	<20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com>
	<1287047542.29097.169.camel@twins>
	<20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
	<1287050395.29097.176.camel@twins>
	<20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikFRLXrdY6_qV5PHeSgH1Dd24ApaHs8R-ixOed=@mail.gmail.com>
	<1287052904.29097.191.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 12:41:44 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-10-14 at 03:25 -0700, Paul Turner wrote:
> > > "When vcpu holds spinlock in kernel, please don't sleep.." will be nice.
> > > Is there patch already ? 
> 
> Oh you're talking about the guest spinlock crap?

yes ;)

> I don't particularly care about that.. that's a virt problem you see ;-)

Hmm. AFAIK, all qemu's thread will be under a cgroup. So, I'll be happy if
a vcpu is on a loop to wait for spinlock yields immediately...But I'm not
famliar with this area, either. Thanks.

-Kame

