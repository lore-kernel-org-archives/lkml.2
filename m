Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2LSSHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:07:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41280 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2LSSHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:07:17 -0500
Message-ID: <50D2023F.1000609@ti.com>
Date: Wed, 19 Dec 2012 23:36:55 +0530
From: R Sricharan <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Luciano Coelho <coelho@ti.com>, <balbi@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
References: <1352968293.10872.51.camel@cumari.coelho.fi>  <20121218095450.GB27751@arwen.pp.htv.fi>  <20121219094552.GN4985@opensource.wolfsonmicro.com>  <50D19040.5090404@ti.com>  <20121219100909.GO4985@opensource.wolfsonmicro.com>  <50D19463.5010605@ti.com>  <20121219103206.GQ4985@opensource.wolfsonmicro.com>  <1355913954.5273.21.camel@cumari.coelho.fi> <50D19D54.2000307@ti.com>  <20121219130128.GC17993@arwen.pp.htv.fi> <50D1C652.3050607@ti.com> <1355925504.5273.26.camel@cumari.coelho.fi> <50D1C957.8090201@ti.com>
In-Reply-To: <50D1C957.8090201@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 19 December 2012 07:34 PM, Benoit Cousson wrote:
> On 12/19/2012 02:58 PM, Luciano Coelho wrote:
>> On Wed, 2012-12-19 at 14:51 +0100, Benoit Cousson wrote:
>>> On 12/19/2012 02:01 PM, Felipe Balbi wrote:
>>>> On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
>>>>> BTW: have you happened to ubdate u-boot recently? There is a nice easter egg
>>>>> added there:
>>>>> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dplls.
>>>>>
>>>>> Which means that _essential_ clocks and pads are no longer configured.
>>>>
>>>> anything essential you can list ?
>>>
>>> Yeah, that u-boot version is just unusable at all with any mainline
>>> kernel, since we are still missing pads conf for every drivers.
>>>
>>> Regarding the 32k clock, I noticed as well that the OMAP4460 panda
>>> u-boot is the only one to enable it at boot time, and thus this is the
>>> only board that can probe the wilink chip properly as of today.
>>
>> Do you mean that with the latest mainline u-boot all boards will have
>> trouble except panda?
>
> I don't know since the u-boot mainline has never ever supported properly
> the SDP4430, I stopped wasting my time with that code a long time ago.
> But the braves who tried using the latest u-boot mainline code that does
> not configure anything anymore had some troubles...
>
   Configuring every pad and clocks in the u-boot was removed to
   force kernel drivers to fix up things. Dependency on boot loader
   was always a problem. Bootloader should not configure anything apart
   from what is required for boot.

Regards,
  Sricharan


