Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab0I0FqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:46:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab0I0FqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:46:12 -0400
Message-ID: <4CA02F96.2000508@biereigel-wb.de>
Date: Mon, 27 Sep 2010 07:45:58 +0200
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Interrupt latency on some 945GM platforms
References: <201009132336.17310.anarsoul@gmail.com>	<201009162306.59508.anarsoul@gmail.com>	<20100924123901.243c85e1@jbarnes-desktop>	<201009242248.36554.anarsoul@gmail.com>	<20100924125153.4fdf0c1b@jbarnes-desktop>	<4C9F262F.7030709@biereigel-wb.de> <AANLkTinZ-A-D=yEsN00dGB=fpTgV72BgrEra9UpkmVHX@mail.gmail.com>
In-Reply-To: <AANLkTinZ-A-D=yEsN00dGB=fpTgV72BgrEra9UpkmVHX@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:3WfuzkrnsA+6md3jHUmwJBFrczX3CgAyvWrgtMsK6P8
 2K90CQZ23cRP6FMWisR3cynoPB/ujONrUMU/3+lGOzB/ALHgoa
 LOfGnSt6cILhGC01XCXsQNI0ihrrjzrQIBXlwRfpxJhkHHiQqz
 bUYmV0vPm7WVQfmYbaRpk/2Pi2tIHXkpJ4X8QaQoAfx1UaRjT/
 URooFB8OS+U3d3dBAvVp/ibr1Hh/MfogQOAGdi6wrQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everyone,
>> just to add on to reports of this problem, there was a Thread here in LKML
>> some months ago targeting the same problem (but not really attacking it at
>> the Chipset driver). As I have one of those Laptops with a 945GM-Chipset and
>> am stuck with the same Problem (disabled tickless now as a workaround and
>> set ticks to 1000) I could maybe do some testing of patches.
>> So what I can summarize is what the others did before: Disabling CPU1 helps,
>> adding nohz=off helps, changing the Clocksource afterwards helps, binding
>> the Interrupt does NOT help.
>> So here's the Link to the old Discussion with follow-ups, maybe you can get
>> some furter information from there.
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-05/msg03696.html
>> We targeted the BIOS itself as everyone in this thread happened to own an
>> Phoenix BIOS with some special version string.
>> best, Stefan
>>     
> does disable msi help with 'pci=nomsi'?
>   
No, here it doesn't.
