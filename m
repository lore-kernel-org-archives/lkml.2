Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1EFPv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:51:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1EFPvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:51:54 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=KCicORRhOoQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=b8VgSBC0AAAA:8 a=XKDW7ASRPWmzK34nlB8A:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/core] perf events, x86: Add SandyBridge
 stalled-cycles-frontend/backend events
From: Steven Rostedt <rostedt@goodmis.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e04d1b23f9706186187dcb0be1a752e48dcc540b@git.kernel.org>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
	 <tip-e04d1b23f9706186187dcb0be1a752e48dcc540b@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 May 2011 11:51:52 -0400
Message-ID: <1304697112.25414.2523.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 07:40 +0000, tip-bot for Lin Ming wrote:
> Commit-ID:  e04d1b23f9706186187dcb0be1a752e48dcc540b
> Gitweb:     http://git.kernel.org/tip/e04d1b23f9706186187dcb0be1a752e48dcc540b
> Author:     Lin Ming <ming.m.lin@intel.com>
> AuthorDate: Fri, 6 May 2011 07:14:02 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 6 May 2011 09:37:03 +0200
> 
> perf events, x86: Add SandyBridge stalled-cycles-frontend/backend events
> 
> Extend the Intel SandyBridge PMU driver with definitions
> for generic front-end and back-end stall events.
> 
> ( As commit 3011203 "perf events, x86: Add Westmere stalled-cycles-frontend/backend
>   events" says, these are only approximations. )

I now get the following build error:

In file included from /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event.c:1449:0:
/home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c: In function 'intel_pmu_init':
/home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1479:27: error: 'PERF_COUNT_HW_STALLED_CYCLES_FRONTEND' undeclared (first use in this fun
ction)
/home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1479:27: note: each undeclared identifier is reported only once for each function it appe
ars in
/home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1481:27: error: 'PERF_COUNT_HW_STALLED_CYCLES_BACKEND' undeclared (first use in this func
tion)

Config can be found here:

http://rostedt.homelinux.com/private/config-sandy-failed

-- Steve


