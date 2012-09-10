Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2IJRAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:00:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51971 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab2IJRAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:00:38 -0400
Message-ID: <504E1C69.30602@ti.com>
Date: Mon, 10 Sep 2012 18:59:21 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH] ARM: dts: AM33XX: fix gpio node numbering to match hardware
References: <1347294020-22661-1-git-send-email-mporter@ti.com> <504E168C.6060603@ti.com> <20120910165210.GJ27758@beef>
In-Reply-To: <20120910165210.GJ27758@beef>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 06:52 PM, Matt Porter wrote:
> On Mon, Sep 10, 2012 at 06:34:20PM +0200, Benoit Cousson wrote:
>> + Tony
>>
>> Hi Matt,
>>
>> 30 minutes too late for my pull request :-(
>>
>> There are a couple of am33xx patches under discussion, so I'll take them
>> and send a for_3.7/dts-part2 pull request if this is not too late for Tony.
> 
> Yeah, believe me, I did a faceplant when I saw your pull request come by
> at the same time I discovered this issue. ;) In particular, AnilKumar's
> user leds patch would need to be adjusted for this change. I can
> resubmit with the user leds dts changes adjusted as well if that
> discussion comes to a conclusion and his patches accepted.

Yeah, I was wondering if the gpios label were already used somewhere.
I've just added this patch on top of my current series.
So you or Anil should just post the missing patches whenever they'll be
available and accepted.

>> On 09/10/2012 06:20 PM, Matt Porter wrote:
>>> On AM33xx, the datasheet and TRM refer to four GPIO instances that
>>> are 0-based, GPIO0-3.
>>
>> Or maybe you should just update the spec to use a 1-based GPIO number
>> like OMAP :-)
> 
> I am powerless here. :)

That's too bad :-(

Benoit

> 
> -Matt
> 
>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>> ---
>>>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>>> index bb31bff..1369bfc 100644
>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>> @@ -62,7 +62,7 @@
>>>  			reg = <0x48200000 0x1000>;
>>>  		};
>>>  
>>> -		gpio1: gpio@44e07000 {
>>> +		gpio0: gpio@44e07000 {
>>>  			compatible = "ti,omap4-gpio";
>>>  			ti,hwmods = "gpio1";
>>>  			gpio-controller;
>>> @@ -74,7 +74,7 @@
>>>  			interrupts = <96>;
>>>  		};
>>>  
>>> -		gpio2: gpio@4804c000 {
>>> +		gpio1: gpio@4804c000 {
>>>  			compatible = "ti,omap4-gpio";
>>>  			ti,hwmods = "gpio2";
>>>  			gpio-controller;
>>> @@ -86,7 +86,7 @@
>>>  			interrupts = <98>;
>>>  		};
>>>  
>>> -		gpio3: gpio@481ac000 {
>>> +		gpio2: gpio@481ac000 {
>>>  			compatible = "ti,omap4-gpio";
>>>  			ti,hwmods = "gpio3";
>>>  			gpio-controller;
>>> @@ -98,7 +98,7 @@
>>>  			interrupts = <32>;
>>>  		};
>>>  
>>> -		gpio4: gpio@481ae000 {
>>> +		gpio3: gpio@481ae000 {
>>>  			compatible = "ti,omap4-gpio";
>>>  			ti,hwmods = "gpio4";
>>>  			gpio-controller;
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

