Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1CQT2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:28:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1CQT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:28:01 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=ZGYZqoe9DqMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=yx6FFVbwNC0u7344T6kA:9 a=0NPiuDzVrhUf8KdW_M_Qnuqvg-YA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] [GIT PULL] futex: Fix WARN_ON triggering on UP
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <20110317192105.308382309@goodmis.org>
References: <20110317192105.308382309@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 15:27:59 -0400
Message-ID: <1300390079.16880.445.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 15:21 -0400, Steven Rostedt wrote:
> Thomas,
> 
> Please pull the rt patches from:

Oops, sorry this is for mainline not -rt, I used the wrong boiler plate.

-- Steve

> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
> 
>     branch: tip/futex/devel
> 
> 
> Steven Rostedt (2):
>       WARN_ON_SMP(): Allow use in if statements on UP
>       futex: Fix WARN_ON() test for UP
> 
> ----
>  include/asm-generic/bug.h |   28 +++++++++++++++++++++++++++-
>  kernel/futex.c            |    4 ++--
>  2 files changed, 29 insertions(+), 3 deletions(-)


