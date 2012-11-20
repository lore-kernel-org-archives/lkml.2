Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2KTC3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:29:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:17004 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2KTC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:29:52 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f616d00000319b-fb-50aaeb1eeb3f
Message-id: <50AAEB15.6000703@samsung.com>
Date: Tue, 20 Nov 2012 11:29:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: anish singh <anish198519851985@gmail.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH] extcon : callback function to read cable property
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
 <1349880328.22926.2.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
 <1349963260.8329.1.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C5643BA10D@BGSMSX101.gar.corp.intel.com>
 <509B0A0F.5000406@samsung.com>
 <20ADAB092842284E95860F279283C5644017F6@BGSMSX101.gar.corp.intel.com>
 <1352521082.1526.230.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56442034B@BGSMSX101.gar.corp.intel.com>
 <CAK7N6vpEbVrM-w+zLytf8BWmwt5j68py4Q64HEy9maCW2OMDjg@mail.gmail.com>
 <20ADAB092842284E95860F279283C56444A584@BGSMSX101.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C56444A584@BGSMSX101.gar.corp.intel.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zXV2516sCDN4uNrC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZU3unsBd0OVbMnr2cqYGxz7SLkZNDQsBEYkrXNTYIW0ziwr31
	QDYXh5DAMkaJ8w87GGGKfp6eywiRmM4ocWX9cmaQBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTML
	qEtMmrcIrERIoItJYt8fNohyLYnvD7azg9gsAqoSPaffsoDYbEDx/S9usIGMERWIkPjVzwES
	FhFQkZja8p0JZC2zwANWiabVIA4nh7CAm0TDke/MEPesYJX4draFFSTBKRAicfTFPkaIBQIS
	3yYfArtNQkBWYtMBsHoJgW52ic2X97JDPCYpcXDFDZYJjGKzkLwzC+GdWUjeWcDIvIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjJCKkdzCuarA4xCjAwajEw/swYVWAEGtiWXFl7iFGCQ5m
	JRHepnKgEG9KYmVValF+fFFpTmrxIUYfoGMnMkuJJucDozWvJN7Q2MDY0NDS0MzU0tQAh7CS
	OG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsZZW5qjAq/c/lh0MiNnz6o3mxU4+a0Mpblu/hZa
	9OtfuNlOiyn3pp5RU4js0X3tmT9t/eVDW55Ec7mYPniYYTrhbqTEngd2S2PYzuYuv7LzFp//
	nu8/L22UljY/rLvo3+pFGmcEE83sFs2e1bnw9YPQfRaC+xZtq12kuXHVyvUPD4Y3z1S+xyf5
	WImlOCPRUIu5qDgRAEWEPme1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQV2516sCDNYeUrW4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGVN7p7AXdDlWzJ69nKmB
	sc+0i5GTQ0LAROLn6bmMELaYxIV769m6GLk4hASmM0pcWb+cGSTBKyAo8WPyPZYuRg4OZgF5
	iSOXskHCzALqEpPmLQIrERLoYpLY94cNolxL4vuD7ewgNouAqkTP6bcsIDYbUHz/ixtsIGNE
	BSIkfvVzgIRFBFQkprZ8ZwJZyyzwgFWiaTWIw8khLOAm0XDkOzPEPStYJb6dbWEFSXAKhEgc
	fbGPcQKjwCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOt2fSOxhX
	NVgcYhTgYFTi4X2YsCpAiDWxrLgy9xCjBAezkghvUzlQiDclsbIqtSg/vqg0J7X4EKMP0HcT
	maVEk/OBqSCvJN7Q2MTMyNLIzNjE3NgYh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsZI
	fbXVVtt/F88xCDUwyTr9VWfFc38LPWmtP4FX/0y1OROfsPZYjJ1JtLZQ5YHXjFw/nK577u5Y
	ttqt9qHrbG0ZfraqKel86fpSWw8IKE1o7HTfo5E//3htzT3lfQ5vnoqsYuSYyWGgvWBK+8L4
	BlNtIRm1T+HtrpxfbQWVZl8RKt/QfvjfMSWW4oxEQy3mouJEAOa9V33kAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 10:39 AM, Tc, Jenny wrote:
>>>>>> I think that the role of extcon subsystem notify changed
>>>>>> state(attached/detached) of cable to notifiee, but if you want to
>>>>>> add property feature of cable, you should solve ambiguous issues.
>>>>>>
>>>>>> First,
>>>>>> This patch only support the properties of charger cable but,
>>>>>> never support property of other cable. The following structure
>>>>>> depend on only charger cable. We can check it the following structure:
>>>>>>   struct extcon_chrg_cbl_props {
>>>>>>           enum extcon_chrgr_cbl_stat cable_state;
>>>>>>           unsigned long mA;
>>>>>>   };
>>>>>>
>>>>>> I think that the patch have to support all of cables for property
>> feature.
>>>>>
>>>>> My suggestion is to have a structure like this
>>>>>
>>>>> struct  extcon_cablel_props {
>>>>>     unsigned int cable_state;
>>>>>             unsigned int data;
>>>> Why can't it be float/long/double??
>>>>> }
>>>>> Not all cables will have more than two states. If any cable has
>>>>> more than two states, the above structure makes it flexible to
>>>>> represent additional state and the data associated
>>>>>
>>>>>>
>>>>>> Second,
>>>>>> Certainly, you should define common properties of all cables and
>>>>>> specific properties of each cable. The properties of charger
>>>>>> cable should never be defined only.
>>>> IMHO the extcon doesn't know anything about the cable except the
>>>> state which is currently it is in and which also is set by the
>>>> provider.I am unable to understand why should extcon provide more
>>>> than what it knows?It should just limit itself to broadcasting the
>>>> cable state and exploiting it for any other information would only lead to
>> more un-necessary code.
>>>> It should be same as IIO subsystem where the consumer and provider
>>>> knows before hand what information they are going to share and with
>>>> what precision and IIO core is just a way to do that.It doesn't know
>>>> anything beyond what is given by the provider.
>>>> Same is the case with driver core where individual driver sets it's
>>>> own private data and the driver core just gives that private data
>>>> back to the driver as and when it needs but parsing the private data
>>>> in the right way is up to the individual driver.
>>>>
>>>> I fail to understand why is not the case here.
>>>
>>> The requirement is different from the IIO case. I am trying to extend
>>> the Power Supply class to support charging in a generic way
>> (https://lkml.org/lkml/2012/10/18/219).
>>> The extcon consumer in this case is not a device driver. It's part of power
>> supply class driver itself.
>>> I am open to any solution to get the cable properties dynamically. Do
>>> you find a better but generic mechanism for this?
>>>
>>> I am trying to extend  extcon just because I couldn’t find any other
>>> subsystem which gives cable notifications. IMHO, it's good if we can
>>> avoid consumer and provider driver level dependencies just by
>>> extending extcon. This will ensure that the same driver will work on any
>> platform as long as it's having the dependency only on extcon.
>>> We shouldn't put any driver level dependency between extcon consumer
>> and provider.
>>> When we do like that, the extcon consumer is expecting the similar
>>> implementation for the provider on all platforms. This may not be
>>> possible
>> Is there anything wrong in assuming similar implementation for all the
>> providers?I think the providers know what it can provide and this may vary
>> quite a lot.Or can we make a generic provider driver which will encompass all
>> the randomness in the various provider drivers?This generic driver will get all
>> the properties and since it will be generice anyone can use it to know what
>> properties to expect.This will keep the extcon design intact.
> 
> Maintainer??

I agreed about opinion of anish singh. The extcon provider driver provide generic

----
struct  extcon_cablel_props {
     unsigned int cable_state;
     unsigned int data;
}
----
You suggested upper structure and said it is only flexible to represent additional state,
But, it is non-standard. What store real data on "unsigned int data"? It isn't determined
and flexible. That is extcon consumer driver should already know type of real data or
value of real data. The extcon consumer driver has strong dependency on extcon provider
driver. In this case, if extcon provider driver can change data value of "unsigned int data",
extcon consumer provider have to be modified according to extcon provider driver.
I think it isn't correct apporach. So, I proposed that we should define properties for all cables.

>>
>>> and does not seems to  be a scalable solution. IMHO, the extcon should
>>> provide a mechanism to retrieve the cable properties. Consumer drivers
>>> can use this API to get the cable properties without knowing the
>>> provider driver implementation. This will  make the extcon drivers more
>> scalable and reusable across multiple platforms.
>>>
>>>>>
>>>>> Hope above structure would be enough to represent the common cable
>>>>> state and it's data. If a cable has more than two states, then
>>>>> extcon_update_state can be used to notify the consumer 1)Provider
>>>>> can just toggle the "state" argument to notify the consumer that
>>>>> cable state is changed OR
>>>>> 2) Add one more argument  like  extcon_update_state(struct
>>>>> extcon_dev *edev, u32 mask, u32 state1, u32 sate2)
>>>> This will cause other drivers to change such as arizona.
>>>>> If the state2 is set, then consumers can use get_cable_properties()
>>>>> to query the cable properties. State2 need to be used only if the
>>>>> cable need to represent more than two state
>>>>>
>>>>>>
>>>>>> Third,
>>>>>> If we finish to decide the properties for all cables, I'd like to
>>>>>> see a example
>>>> Why do we think that state and property is the only thing which the
>>>> consumer want to know?I am sure there would be some more properties
>>>> which would be of some interest to consumers and there is quite a
>>>> possibility that in future we might get a patch for that also.So
>>>> instead of that limiting it to just state is a good idea.
>>>>>> code.
>>>>>
>>>>> Agreed. If we  agree on the above structure, I can modify the
>>>>> charging subsystem patch to use the same structure.
>>>>> (https://lkml.org/lkml/2012/10/18/219). This would give a reference
>>>>> for the
>>>> new feature.
>>>>>
>>>>>>
>>>>>> You explained following changed state of USB according to Host
>>>>>> state on other patch.
>>>>>> ---------------------------
>>>>>> For USB2.0
>>>>>> 1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
>>>>>> 2) CONNECT (100mA)->UPDATE(500mA)->HOST
>>>> SUSPEND(2.5mA/500mA)-
>>>>>>> DISCONNECT(0mA)
>>>>>> 3) CONNECT (100mA)->UPDATE(500mA)->HOST
>>>> SUSPEND(2.5mA/500mA)-
>>>>>>> HOST RESUME(500mA)->DISCONNECT(0mA)
>>>>>>
>>>>>> For USB 3.0
>>>>>> 4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
>>>>>> 5) CONNECT (150mA)->UPDATE(900mA)-> HOST
>>>> SUSPEND(2.5mA/900mA)-
>>>>>>> DISCONNECT(0mA)
>>>>>> 6) CONNECT (100mA)->UPDATE(900mA)->HOST
>>>> SUSPEND(2.5mA/900mA)-
>>>>>>> HOST RESUME(900mA)->DISCONNECT(0mA)
>>>>>> ---------------------------
>>>>>>
>>>>>> I have a question. Can the provider device driver(e.g.,
>>>>>> extcon-max77693.c/
>>>>>> extcon-max8997.c) detect the changed state of host? I'd like to
>>>>>> see the example device driver that the provider device driver
>>>>>> detect changed state of host.
>>>>>> Could you provide example device driver?
>>>>>
>>>>> Good question. The OTG drivers are capable of identifying the
>>>>> SUSPEND
>>>> event.
>>>>> System cannot setup SDP (USB host) charging with maximum charging
>>>>> current - 500mA (USB2.0/ 900mA(USB 3)) without enumerating the USB.
>>>>> The USB enumeration can be done only with a USB/OTG driver. IMHO
>>>>> the above extcon drivers (extcon-max77693.c/ extcon-max8997.c) are
>>>>> not capable of doing the USB enumeration and identifying the charge
>>>>> current. They can just identify the charger type -
>> SDP/DCP/CDP/ACA/AC.
>>>>> The intelligence for USB enumeration should be inside USB/OTG driver.


