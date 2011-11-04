Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1KDVuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:50:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54755 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1KDVuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <201111031118.21407.jbe@pengutronix.de>
References: <1636461.EdGrGCQCuj@quad>
	<201111031118.21407.jbe@pengutronix.de>
Date: Fri, 4 Nov 2011 22:50:15 +0100
Message-ID: <CAAfyv37ZJhhYgRWQW_zPsGPU6m_QuqGOPrTcbs2bfg6tibE0bg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.1.0-ck1
From: Belisko Marek <marek.belisko@gmail.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: Con Kolivas <con@kolivas.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 11:18 AM, Juergen Beisert <jbe@pengutronix.de> wrote:
> Con Kolivas wrote:
>> These are patches designed to improve system responsiveness and
>> interactivity with specific emphasis on the desktop, but suitable to any
>> commodity hardware workload.
>>
>> As it may take some time to get a kernel.org account, I have started
>> hosting these patches exclusively on my site for now.
>>
>>
>> Apply to 3.1.x:
>> http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/patch-3.1.0-ck1.bz2
>
> Tried here with Mini2440 (=ARM arch) to compile:
Seems in kernel/sched_bfs.c is missing #include <linux/prefetch.h>
With that fix it compiles fine. Problem is that prefetch is defined in
ARM headers only for version > v5 (mini is v4).
>
> [...]
> In file included from kernel/sched.c:2:0:
> kernel/sched_bfs.c: In function 'schedule':
> kernel/sched_bfs.c:3224:4: error: implicit declaration of function 'prefetch'
> [...]
>
>> Broken out tarball:
>> http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/3.1.0-ck1-broken-out.tar.bz2
>
> This ^ one I tried to apply, but it fails with:
> [...]
> patching file include/linux/sched.h
> Hunk #1 FAILED at 1600.
> Hunk #2 FAILED at 1647.
> 2 out of 2 hunks FAILED -- rejects in file include/linux/sched.h
> can't find file to patch at input line 214
> Perhaps you used the wrong -p or --strip option?
> The text leading up to this was:
> --------------------------
> |Index: linux-3.1-ck/kernel/sched_bfs.c
> |===================================================================
> |--- linux-3.1-ck.orig/kernel/sched_bfs.c       2011-11-03 14:44:23.000000000 +1100
> |+++ linux-3.1-ck/kernel/sched_bfs.c    2011-11-03 14:46:02.157115770 +1100
> --------------------------
> No file to patch.  Skipping patch.
> 1 out of 1 hunk ignored
> [...]
>
> Regards,
> Juergen
>
> --
> Pengutronix e.K.                              | Juergen Beisert             |
> Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
