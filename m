Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0LOPCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:02:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0LOPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:02:01 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_YN-YSBCZZuuKr2N7HIA:9 a=dyW98CHlEwFYJEa7U-9C0SUiXwUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1012151550190.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
	 <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
	 <alpine.LFD.2.00.1012151550190.12146@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 10:01:58 -0500
Message-ID: <1292425318.5015.1892.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 15:52 +0100, Thomas Gleixner wrote:

> RT itself will stress test the rtmutex code as much as it goes as we
> convert almost every lock into a rtmutex there.
> 
> Steven, could you have a look at that ?
> 

Yep, I'll look to porting it today.

-- Steve


