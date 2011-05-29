Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1E2XvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:51:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1E2XvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:51:01 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=XYJHFtupD_QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Y-KhlWonE5oM3mTLo1QA:9 a=mliqP3F_AWVc13CM3PUA:7 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Sun, 29 May 2011 19:50:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 hangs on boot
Message-ID: <20110529235058.GC10792@home.goodmis.org>
References: <201105282235.24530.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105282235.24530.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:35:24PM +0200, Markus wrote:
> Hi!
> 
> I tried the vanilla 2.6.39 today, but it doesnt even boot. The last 
> lines I see are:
> Refined TSC clocksource calibration: 3210.779 MHz.
> Switching to clocksource tsc
> 
> After that nothing more happens. After a minute I rebooted into a 2.6.38 
> kernel, it worked:
> $ dmesg | grep clocksource
> Switching to clocksource hpet
> Refined TSC clocksource calibration: 3210.778 MHz.
> Switching to clocksource tsc
> 
> 
> Issue known? Any patch/workaround? How could I help?

Could you send me your .config file.

As this weekend (and Monday) is a holiday in the US, I'll probably not
look at it till Tuesday.


> 
> 
> Markus
> 
> PS: Please CC me.

That is the only way to communicate on LKML, as no one actually reads
all the emails (well almost no one). It generates 600 messages a day.

-- Steve

