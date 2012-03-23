Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2CWXrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:47:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38207 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2CWXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:47:09 -0400
Message-ID: <4F6D0B77.6070600@linaro.org>
Date: Fri, 23 Mar 2012 16:47:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86-64: Simplify and speed up vdso clock_gettime
References: <cover.1332475308.git.luto@amacapital.net>
In-Reply-To: <cover.1332475308.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032323-1780-0000-0000-00000436951F
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000263; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00124635; UDB=6.00029813; UTC=2012-03-23
 23:47:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 09:15 PM, Andy Lutomirski wrote:
> I think clock_gettime is already almost as fast as possible, but every
> little bit helps.  Also, I think the diffstat is pretty good for a
> speedup.  Here are some approximate timings.
>
>                               Before       After
> CLOCK_REALTIME                 16.7        15.2
> CLOCK_MONOTONIC                17.3        15.5
> CLOCK_REALTIME_COARSE           3.6         3.0
> CLOCK_MONOTONIC_COARSE          4.2         3.6
>
> These are extracted from an earlier series that's mostly abandoned now [1-2].
> They apply to tip/timers/core commit 57779dc2b3b75bee05ef5d1ada47f615f7a13932.
>
> For the git-inclined, the patches are here:
> https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/timing/vclock_speedup/patch_v1
>
> I'm not sure whether these are 3.4 material.  On the pro side, they've
> technically been floating around since long before the merge window.
> They're also quite straightforward, and they're based on other -tip
> changes (which is why I'm submitting now).  On the con side, they don't
> fix anything, and they're a little later than ideal.

The look straightforward enough. I've queued them at the end of my 3.4 
queue. If Thomas or anyone wants to wait on them, I'll push them off to 3.5

thanks
-john

