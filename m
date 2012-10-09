Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2JIM1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:27:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46504 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab2JIM1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:27:16 -0400
Message-ID: <507417EA.3010008@ti.com>
Date: Tue, 9 Oct 2012 17:56:18 +0530
From: Afzal Mohammed <x0148406@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob@landley.net" <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] omap-am33xx rtc dt support
References: <cover.1343383616.git.afzal@ti.com> <50256797.3020505@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93E9BA4EB@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E9BA4EB@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


On Monday 27 August 2012 01:05 PM, Mohammed, Afzal wrote:
> On Sat, Aug 11, 2012 at 01:27:11, Nori, Sekhar wrote:
>> On 7/27/2012 5:53 PM, Afzal Mohammed wrote:

>>> This series makes rtc-omap driver DT capable, adds AM33xx
>>> RTC DT support along with a few enchancments to the driver.
>>>
>>> rtc-omap driver is made intelligent enough to handle kicker
>>> mechanism. This helps in removing kicker mechanism support
>>> done for DaVinci at platform level.
>>>
>>> This has been tested on Beaglebone (AM33xx platform) and on
>>> DaVinci DA850 EVM.

>> I tested patches 1-5 on AM18x EVM using rtcwake and hwclock commands.
>> Also tested on DT enabled AM18x EVM using hwclock.
>>
>> For patched 1-5:
>>
>> Acked-by: Sekhar Nori<nsekhar@ti.com>
>>
>> Alessandro,
>>
>> I assume you would want me to queue 2/6 through DaVinci tree. That patch
>> depends on 1/6 being accepted and merged by you. Let me know how you
>> want to move forward here.
> Can you please help 1-5 patches in this series to get into mainline.
> 1-5 of this series is a prerequisite for adding RTC support for AM335X
> SoC's, which is present in beaglebone, AM335X EVM.

This series which adds rtc support for AM335x SoC (ARM
Cortex-A8 from TI) based boards (like beagle bone) and
in the process making omap rtc driver device tree capable
was posted after addressing review comments around
July end. It seems rtc maintainer is not active and you
are taking care of the rtc patches.

Patches 1-5 has been Acked by DaVinci maintainer.

Can you please help this series reach mainline, let me
know whether this series needs to be reposted.

I waited to see response from rtc maintainer, it seems wait went
too far and this mail should have been sent a couple of weeks
before start of merge window.

As merge window is coming to an end, I feel it may be bad to
ask you this , but still: would it be possible to get the series in
during this merge window.

A recap of what this series is about,

omap-rtc driver used by DaVinci and OMAP1 platforms is being
reused for AM335x. Kicker release mechanism that is handled
by DaVinci platform code has been moved to rtc driver. AM335x
also needs to handle kicker mechanism. DT support has been
added to omap-rtc driver, this was necessitated as AM335x
supports only DT boot (DaVinci platform is also going DT way)
Patch 6 adds AM335x DT support (this probably should go
through omap tree). This series has been tested on beagle bone
and DaVinci DA850 EVM.

Regards
Afzal
