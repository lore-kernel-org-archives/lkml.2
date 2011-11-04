Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1KDWiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:38:22 -0400
Received: from home.kolivas.org ([59.167.196.135]:43016 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973Ab1KDWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:38:20 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 3.1.0-ck1
Date: Sat, 05 Nov 2011 09:37:35 +1100
Message-ID: <6835841.YG8RRyOs5I@quad>
User-Agent: KMail/4.7.2 (Linux/3.1.0-ck1; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CAAfyv37ZJhhYgRWQW_zPsGPU6m_QuqGOPrTcbs2bfg6tibE0bg@mail.gmail.com>
References: <1636461.EdGrGCQCuj@quad> <201111031118.21407.jbe@pengutronix.de> <CAAfyv37ZJhhYgRWQW_zPsGPU6m_QuqGOPrTcbs2bfg6tibE0bg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Nov 2011 22:50:15 Belisko Marek wrote:
> On Thu, Nov 3, 2011 at 11:18 AM, Juergen Beisert <jbe@pengutronix.de> wrote:
> > Con Kolivas wrote:
> >> These are patches designed to improve system responsiveness and
> >> interactivity with specific emphasis on the desktop, but suitable to
> >> any
> >> commodity hardware workload.
> >> 
> >> As it may take some time to get a kernel.org account, I have started
> >> hosting these patches exclusively on my site for now.
> >> 
> >> 
> >> Apply to 3.1.x:
> >> http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/patch-3.1.0-ck1.bz2
> > 
> > Tried here with Mini2440 (=ARM arch) to compile:
> Seems in kernel/sched_bfs.c is missing #include <linux/prefetch.h>
> With that fix it compiles fine. Problem is that prefetch is defined in
> ARM headers only for version > v5 (mini is v4).

Thanks for that. The prefetch is only of questionable advantage so it can be 
removed entirely. The following patch should fix it:

http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/bfs414-noprefetch.patch

Regards,
Con

-- 
-ck
