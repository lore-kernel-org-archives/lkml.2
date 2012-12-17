Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2LQAii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 19:38:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50411 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2LQAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 19:38:37 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f616d00000319b-5e-50ce698bf6b9
Message-id: <50CE698A.4080002@samsung.com>
Date: Mon, 17 Dec 2012 09:38:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: anish kumar <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH] EXTCON: Get and set cable properties
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
 <50BBFCB8.4080903@samsung.com>
 <20ADAB092842284E95860F279283C564E29388@BGSMSX101.gar.corp.intel.com>
 <1354512564.1600.117.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C564E4D554@BGSMSX101.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C564E4D554@BGSMSX101.gar.corp.intel.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zXd3uzHMBBlfvCFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M3jXTWAqmyVW8mLSGpYHxokQXIyeHhICJxNYXu5ghbDGJC/fW
	s3UxcnEICSxjlOi81soMU9S97RwLRGIRo8SMOz/ZQRK8AoISPybfA0pwcDALyEscuZQNEmYW
	UJeYNG8RWK+QQBeTxOHVZhDlWhLNR2aBxVkEVCWmN/9kA7HZgOL7X9xgAxkjKhAh8aufAyQs
	IqAiMbXlOxPEyCXMEnNXmYPYwgKWEm9mNbFDjF/KJPH2AR+IzSkQInGgZw4bxHgBiW+TD4Fd
	JiEgK7HpANQn7ewSff2KELakxMEVN1gmMIrNQvLLLIRfZiH5ZQEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2MkFiQ3sG4qsHiEKMAB6MSD69h6rkAIdbEsuLK3EOMEhzMSiK8/O5AId6U
	xMqq1KL8+KLSnNTiQ4w+QLdOZJYSTc4HxmleSbyhsYGxoaGloZmppakBDmElcd5mj5QAIYH0
	xJLU7NTUgtQimHFMHJxSDYzcyr37tr6Rnyec0C1TUtKvOnfla4FNn2fI8jUx2cz9yRS1pfjM
	jphmBh3LqU8K9vueqdqwwltw341+C+4Lvxf/eZRtcWnCSfm7QXYuD3bWHzzp4fxuwSrvCd/1
	fSRyp6h6zpoWOrvk55mupLsr+HI4eCqecn6ImnhMdm51/g0XyyxPze9tYZZKLMUZiYZazEXF
	iQC7yajWsgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd3uzHMBBvM62C0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRu+aaSwF0+QqXkxaw9LA
	eFGii5GTQ0LARKJ72zkWCFtM4sK99WxdjFwcQgKLGCVm3PnJDpLgFRCU+DH5HlARBwezgLzE
	kUvZIGFmAXWJSfMWMYPYQgJdTBKHV5tBlGtJNB+ZBRZnEVCVmN78kw3EZgOK739xgw1kjKhA
	hMSvfg6QsIiAisTUlu9MECOXMEvMXWUOYgsLWEq8mdXEDjF+KZPE2wd8IDanQIjEgZ45bBMY
	BWYhOW4WwnGzkBy3gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwrD2T3sG4qsHiEKMA
	B6MSD69h6rkAIdbEsuLK3EOMEhzMSiK8/O5AId6UxMqq1KL8+KLSnNTiQ4w+QL9NZJYSTc4H
	poG8knhDYxMzI0sjM2MTc2NjHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhgT6idM7NA0
	1PNaKCCkz6e/92z4tPBXx56vMFv2JGr5rW+T1N9ey/U43HtKlP34J+89x9wbAzKOrHOWeO66
	yGg2o6nVewFJaZ7sH3xZ69cyMghOd9DPYXzcnSJ7i8Fqu+tf9z+31zhEmhrdlP69m+eu0uVX
	T4T4Y42KYuzdf054NYn3zznm9GolluKMREMt5qLiRAATJEO04gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 09:16 AM, Tc, Jenny wrote:
> 
>>> I replied on the thread and pointed out issues that I see with this
>>> solution. IMHO It's not fair to register a cable with
>>> power_supply/regulator/charger manager just to expose the cable
>> properties.
>> Don't we do that with already in allmost all drivers?Like if I have a keyboard
>> driver and then I register with input framework and if the keyboard driver
>> needs clk services then I register with clk framework as well and same with
>> other services needed by keyboard driver.I think it makes sense for a cable
>> to register with different framework if it supports that functionality as those
>> services also would know that we have a cable with so and so property.
> 
> IMHO it's not a good choice to register a cable itself with any of the three subsystem
> (power_supply/regulator/charger manager)
> 
>  For example it cannot register with power_supply subsystem since it's not a 
>  power_supply. It's just source for a power_supply.We register either charger/battery with
>  power supply. I couldn't find a way to register the cable with power supply subsystem. 
> 
> In previous discussion Anton also agreed to this.
> 
> Anton,
> Could you please confirm?
> 
> I think the same case with regulator framework also. A cable doesn’t belong to a regulator framework.
> A cable doesn’t expose any control attribute (current control/voltage control). It just have  properties (eg current)
>  controlled by external agents (Host machine/wall charger)
> 
> And charger manager is a consumer and not a provider. It cannot decide the charger cable capabilities.
No, charger-manager include information for battery/charger/charger cable dependency on target H/W.
Each target has different h/w constraint for charging, so charger-manager can determine whether
specific charger cable is used on target or not.

> 
> 
>>>> As I said, extcon provider driver didn't provide directly charging
>>>> current(int
>>>> mA) and some state(unsigned long state) because the extcon provider
>>>> driver(Micro USB interface controller device or other device related
>>>> to external connector) haven't mechanism which detect dynamically
>>>> charging current immediately. If you wish to provide charging
>>>> current data to extcon consumer driver or framework, you should use
>>>> regulator/power_supply framework or other method in extcon provider
>> driver.
> 
> This information need not to come from the extcon provider. It can come from any driver
> Who knows the state of a cable. It may be a platform driver or may be a driver belongs to any
> of the three subsystem we discussed above (power_supply/regulator/charger_manager).
> Just by having an API like this (extcon_cable_set_data), it's not mandatory to register the cable
> with any of the subsystem.
> 
>>>> Also if you want to define 'struct extcon_chrgr_cable_props', you
>>>> should certainly show how detect dynamically charging current or state.
> 
> For USB cables, it's determined by USB enumeration. For USB 3.0 it would be 900mA and
> USB 2.0 it's 500mA. Also in un configured  state this would be 150 and 100mA respectively
I think only USB enumeration determine standard charging current according to version of USB.
But, Extcon subsystem always need detection mechanism. (e.g, Jack/Microphone detection device
of Wolfson sound codec and MUIC(Micro USB Interface Controller) device of MAXIM)

You didn't show any detection mechanism which detect changed state of host system.

What can some device for detecting of following host state except of CONNECT/DISCONNECT state?
I don't know. Please let me know it.

- SUSPEND(Host suspend for SDP cable),
- RESUME(Host wakeup)
- UPDATE (to increase the charge current after USB enumaeration).
- CONNECT
- DISCOONECT


