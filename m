Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1AHCXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 21:23:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44808
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1AHCXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 21:23:19 -0500
Date: Fri, 07 Jan 2011 18:23:50 -0800 (PST)
Message-Id: <20110107.182350.193715518.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc boot failure due to perf init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294431832.2016.457.camel@laptop>
References: <20110107201805.GA28104@merkur.ravnborg.org>
	<1294431832.2016.457.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 07 Jan 2011 21:23:52 +0100

> On Fri, 2011-01-07 at 21:18 +0100, Sam Ravnborg wrote:
>> This was introduced by: 
>> "perf, arch: Cleanup perf-pmu init vs lockup-detector" - 004417a6d468e24399e383645c068b498eed84ad
>> 
>> I did not see any obvious fix.
>> (To avoid it is simple - I can disable it in my config).
> 
> Or you can switch back to arch_initcall() for now, it'll cause the
> generic watchdog stuff not to work, but that's a lot less important.
> 
> I'll have a chat with Dave on how to best sort all this.

I'll take a look at this.

Thanks for bisecting this down Sam, I was seeing the same problem
on my machines and was about to debug it myself.
