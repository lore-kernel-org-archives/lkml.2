Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2KFQKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:10:35 -0500
Received: from smtp.domeneshop.no ([194.63.252.54]:54706 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KFQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:10:33 -0500
Message-ID: <50993696.8040006@paradoxuncreated.com>
Date: Tue, 06 Nov 2012 17:11:02 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Help low-jitter man.
References: <50992F56.3080209@paradoxuncreated.com>
In-Reply-To: <50992F56.3080209@paradoxuncreated.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 06.11.2012 16:40, skrev Ove Karlsen:
> Heya, it`s me again. I am getting my low-jitter E5 computer, soon, and I
> have done all the tweaks I can think of with the kernel.
>
> I was wondering if anyone had anything to add, any good technical
> opinion on reducing jitter (for workstation desktop/OpenGL).
>
> I have a kernel with "low latency desktop" enabled. And edited
> Kconfig.hz to 90.
> idle=poll and tick_skew=1 in boot options.
> Compile a shaved local kernel by doing "make localmodconfig" from a full
> distro kernel.
> (Also turned of high_res_timers, to get 90hz)
>
> CFS granularity 1158500nS. (Current setting is a bit high)
> Reniced X to -20, to prevent X being a bottleneck.
> Remove 60hz limit in doom 3, to avoid timing jitter.
> http://paradoxuncreated.com/tmp/AutoExec.cfg
>
> Some nvidia-specific stuff on my blog aswell :
> http://paradoxuncreated.com/Blog/wordpress/?p=2268
>
> A lot of people think SLAB has lower jitter than SLUB etc, aswell, and
> some tuning with regards to what kernel options execute the least code,
> least background activity can be done. Opinions?
>
> I use SLUB currently, and have turned off mem-compaction.
> And probably all kinds of debugging, counters and tracers.
>
> RCU boost to 99.
>
> I think I have collected most the relevant data for a low-jitter linux
> config. but in case there is additional information, I would love to
> hear it.
>
> Also ACPI on or off seems to be varying opions on. Some state ACPI
> removes SMI`s? I don`t know what is true here, and knowing that some
> recommend 10000hz timer for "low-jitter" (which is going the completely
> wrong way) I would like to hear your opinion on this aswell.
>
> Also approaching a transparent OS, with realtime-threads is interesting.
> Such as running maintask (optionally + depencies) as realtime.
> Unfortunately it doesn`t seem to work so well with standard FIFO. Do you
> think deadline could help this? Accurate 0.95ms of 1ms would be
> interesting to try.
>
> Also if anyone knows a linux-distro with the same philosophy throughout
> the OS, I would be interested to know about it.
>

Also have anyone given any thoughts to vsynced HZ? And also even 
possibly dividing subhz off that, or more hz counters if neccesary.

-- 
Fred være med deg / Peace Be with You,
Ove Karlsen
http://www.paradoxuncreated.com
