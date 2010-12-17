Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0LQDRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:17:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0LQDRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:17:46 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Blh0GfQebR7eN_TS9cEA:9 a=wUKGmcczNQoaeEwPm6w50-NrZ3QA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Lai Jiangshan <eag0628@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D0AD4A8.7050206@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
	 <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
	 <4D0A77B5.3040900@linux.intel.com>  <4D0AD4A8.7050206@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Dec 2010 22:17:42 -0500
Message-ID: <1292555862.22905.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 11:10 +0800, Lai Jiangshan wrote:
> On 12/17/2010 04:33 AM, Darren Hart wrote:

> I also try to port it to -rt. Steven, have you ported it to -rt?

I'm porting it now. -rt does a a bit to the rtmutex.c code, and I spent
a bit of time cleaning it up. I finally got your patch to compile, and
now I'm debugging it ;-)

I'm hoping to have it ready to post tomorrow.

-- Steve


