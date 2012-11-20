Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2KTGKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:10:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27426 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTGKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:10:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa66d0000004cf-95-50ab1ed6e8af
Message-id: <50AB1ECA.5020005@samsung.com>
Date: Tue, 20 Nov 2012 15:10:18 +0900
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
 <50AAEB15.6000703@samsung.com>
 <20ADAB092842284E95860F279283C56444A6A1@BGSMSX101.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C56444A6A1@BGSMSX101.gar.corp.intel.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zHd1rcqsDDH6fFbW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ55+uYC34E1RxceF21gbGCS5djJwcEgImEk9udbFB2GISF+6t
	B7K5OIQEljFKzGl/xAZTtGtdEyOILSQwnVFi5qNMEJtXQFDix+R7LF2MHBzMAvISRy5lg4SZ
	BdQlJs1bxAwxp4tJ4tiMo0wQ9VoSr+Y+YwGxWQRUJY5seMoKYrMBxfe/uMEGMkdUIELiVz8H
	SFhEQEViast3JpA5zAIPWCWaVn8HmyMs4CbRcOQ71IKJbBJvphwFG8QpECLxZPoBqAUCEt8m
	HwI7TkJAVmLTAbB6CYFudonfMxYxQjwmKXFwxQ2WCYxis5D8Mwvhn1lI/lnAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIyQipHYwrmywOMQowMGoxMP7MGFVgBBrYllxZe4hRgkOZiUR
	3qZyoBBvSmJlVWpRfnxRaU5q8SFGH6BjJzJLiSbnA6M1ryTe0NjA2NDQ0tDM1NLUAIewkjhv
	s0dKgJBAemJJanZqakFqEcw4Jg5OqQbG6FvPo44uOqtmPWfZR5M7xYn9R91snu4sF1s98/PU
	5oS67JbH/37eORRXollr6DX1cs7hDbUbb4ufDkmX/fXyc0yh4cn7ZXahGxh3Tbs479SzVf1K
	hb/ieVL9epT+V2+4Xxj94rjRtp+n0vRNmn2yZike83Vs06/4tkipa/7xyA9Ka18ze2yuVGIp
	zkg01GIuKk4EAJ+Drnm1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd1rcqsDDM4t47e4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGeefrmAt+BNUcXHhdtYG
	xgkuXYycHBICJhK71jUxQthiEhfurWcDsYUEpjNKzHyUCWLzCghK/Jh8j6WLkYODWUBe4sil
	bJAws4C6xKR5i5i7GLmAyruYJI7NOMoEUa8l8WruMxYQm0VAVeLIhqesIDYbUHz/ixtsIHNE
	BSIkfvVzgIRFBFQkprZ8ZwKZwyzwgFWiafV3sDnCAm4SDUe+Qy2YyCbxZspRsEGcAiEST6Yf
	YJnAKDALyX2zEO6bheS+BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4+2Z1A7GlQ0W
	hxgFOBiVeHgfJqwKEGJNLCuuzD3EKMHBrCTC21QOFOJNSaysSi3Kjy8qzUktPsToA/TdRGYp
	0eR8YCrIK4k3NDYxM7I0MjM2MTc2xiGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoEx6Vem
	VvXLE5p3o2vff2GqORM5N6Mv8w7nb/XiwCUhvkUnBeRrPs1qS/uyav2ufp/Te34v1ptXwBuV
	mV28veq7XuzKnbFnj61vcd36g6NDyKDdmaft2DxTN8HAhaWlvO2+n6ZWTHxzXP7EHNaGUJ+J
	MY6M1y0kzu+fsTGwdVWGlYW/D7/ft0tKLMUZiYZazEXFiQC/AJ9s5AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 11:42 AM, Tc, Jenny wrote:
>>>>>>>> I think that the role of extcon subsystem notify changed
>>>>>>>> state(attached/detached) of cable to notifiee, but if you want to
>>>>>>>> add property feature of cable, you should solve ambiguous issues.
>>>>>>>>
>>>>>>>> First,
>>>>>>>> This patch only support the properties of charger cable but,
>>>>>>>> never support property of other cable. The following structure
>>>>>>>> depend on only charger cable. We can check it the following
>> structure:
>>>>>>>>   struct extcon_chrg_cbl_props {
>>>>>>>>           enum extcon_chrgr_cbl_stat cable_state;
>>>>>>>>           unsigned long mA;
>>>>>>>>   };
>>>>>>>>
>>>>>>>> I think that the patch have to support all of cables for property
>>>> feature.
>>>>>>>
>>>>>>> My suggestion is to have a structure like this
>>>>>>>
>>>>>>> struct  extcon_cablel_props {
>>>>>>>     unsigned int cable_state;
>>>>>>>             unsigned int data;
>>>>>> Why can't it be float/long/double??
>>>>>>> }
>>>>>>> Not all cables will have more than two states. If any cable has
>>>>>>> more than two states, the above structure makes it flexible to
>>>>>>> represent additional state and the data associated
>>>>>>>
>>>>>>>>
>>>>>>>> Second,
>>>>>>>> Certainly, you should define common properties of all cables and
>>>>>>>> specific properties of each cable. The properties of charger
>>>>>>>> cable should never be defined only.
>>>>>> IMHO the extcon doesn't know anything about the cable except the
>>>>>> state which is currently it is in and which also is set by the
>>>>>> provider.I am unable to understand why should extcon provide more
>>>>>> than what it knows?It should just limit itself to broadcasting the
>>>>>> cable state and exploiting it for any other information would only
>>>>>> lead to
>>>> more un-necessary code.
>>>>>> It should be same as IIO subsystem where the consumer and provider
>>>>>> knows before hand what information they are going to share and with
>>>>>> what precision and IIO core is just a way to do that.It doesn't
>>>>>> know anything beyond what is given by the provider.
>>>>>> Same is the case with driver core where individual driver sets it's
>>>>>> own private data and the driver core just gives that private data
>>>>>> back to the driver as and when it needs but parsing the private
>>>>>> data in the right way is up to the individual driver.
>>>>>>
>>>>>> I fail to understand why is not the case here.
>>>>>
>>>>> The requirement is different from the IIO case. I am trying to
>>>>> extend the Power Supply class to support charging in a generic way
>>>> (https://lkml.org/lkml/2012/10/18/219).
>>>>> The extcon consumer in this case is not a device driver. It's part
>>>>> of power
>>>> supply class driver itself.
>>>>> I am open to any solution to get the cable properties dynamically.
>>>>> Do you find a better but generic mechanism for this?
>>>>>
>>>>> I am trying to extend  extcon just because I couldn’t find any other
>>>>> subsystem which gives cable notifications. IMHO, it's good if we can
>>>>> avoid consumer and provider driver level dependencies just by
>>>>> extending extcon. This will ensure that the same driver will work on
>>>>> any
>>>> platform as long as it's having the dependency only on extcon.
>>>>> We shouldn't put any driver level dependency between extcon
>> consumer
>>>> and provider.
>>>>> When we do like that, the extcon consumer is expecting the similar
>>>>> implementation for the provider on all platforms. This may not be
>>>>> possible
>>>> Is there anything wrong in assuming similar implementation for all
>>>> the providers?I think the providers know what it can provide and this
>>>> may vary quite a lot.Or can we make a generic provider driver which
>>>> will encompass all the randomness in the various provider
>>>> drivers?This generic driver will get all the properties and since it
>>>> will be generice anyone can use it to know what properties to expect.This
>> will keep the extcon design intact.
>>>
>>> Maintainer??
>>
>> I agreed about opinion of anish singh. The extcon provider driver provide
>> generic
>>
>> ----
>> struct  extcon_cablel_props {
>>      unsigned int cable_state;
>>      unsigned int data;
>> }
>> ----
>> You suggested upper structure and said it is only flexible to represent
>> additional state, But, it is non-standard. What store real data on "unsigned int
>> data"? It isn't determined and flexible. That is extcon consumer driver should
>> already know type of real data or value of real data. The extcon consumer
>> driver has strong dependency on extcon provider driver. In this case, if
>> extcon provider driver can change data value of "unsigned int data", extcon
>> consumer provider have to be modified according to extcon provider driver.
>> I think it isn't correct apporach. So, I proposed that we should define
>> properties for all cables.
> 
> I couldn’t find properties common for all type of cables. Alternate method I can think of is
> a new driver "extcon-charger.c".  This driver will register with extcon subsystem.
> 
> The consumer and provider can use the APIs and properties exposed by this driver.  This
> way we can ensure that extcon design is intact and the additional charger cable state and
> properties can be handled by this driver. Does that make sense?

I don't agree about 'extcon-charger.c' because the 'extcon-class.c' driver support already charger
cable.
Also it is duplicate feature between 'extcon-class.c' and 'extcon-charger.c'.

Also,
The obvious difference between the state of external cable and the state of host system is existence.
I think that extcon cable state isn't changed when state of host system
move from normal state to suspend state or opposite case. If consumer driver
hope to know new state of host system, power_supply charging framework
communicate with other driver or framework that provide API for checking state
of host system.

I suggest a approach that some framework related OTG/USB need to implement
something like below notifier block, this notifier block inform changed state
of host system of some driver/framework that need state of host system.

/*
  * Host system notifier
  */
#define HOST_SYSTEM_NORMAL		0x1
#define HOST_SYSTEM_SUSPEND	0x2

extern int register_host_system_notifier(struct notifier_block *nb);
extern void unregister_host_system_notifier(struct notifier_block *nb);
int host_system_notify(..)

For example,
Firstly, the power_supply charging framework check state of charger cable whether
attached or detached cable. Second, when power_supply charging framework
receive the changed state of host system from 'Host system notifier',
change charging current of charger cable.

> 
>>
>>>>
>>>>> and does not seems to  be a scalable solution. IMHO, the extcon
>>>>> should provide a mechanism to retrieve the cable properties.
>>>>> Consumer drivers can use this API to get the cable properties
>>>>> without knowing the provider driver implementation. This will  make
>>>>> the extcon drivers more
>>>> scalable and reusable across multiple platforms.
>>>>>
>>>>>>>
>>>>>>> Hope above structure would be enough to represent the common
>> cable
>>>>>>> state and it's data. If a cable has more than two states, then
>>>>>>> extcon_update_state can be used to notify the consumer 1)Provider
>>>>>>> can just toggle the "state" argument to notify the consumer that
>>>>>>> cable state is changed OR
>>>>>>> 2) Add one more argument  like  extcon_update_state(struct
>>>>>>> extcon_dev *edev, u32 mask, u32 state1, u32 sate2)
>>>>>> This will cause other drivers to change such as arizona.
>>>>>>> If the state2 is set, then consumers can use
>>>>>>> get_cable_properties() to query the cable properties. State2 need
>>>>>>> to be used only if the cable need to represent more than two state
>>>>>>>
>>>>>>>>
>>>>>>>> Third,
>>>>>>>> If we finish to decide the properties for all cables, I'd like to
>>>>>>>> see a example
>>>>>> Why do we think that state and property is the only thing which the
>>>>>> consumer want to know?I am sure there would be some more
>> properties
>>>>>> which would be of some interest to consumers and there is quite a
>>>>>> possibility that in future we might get a patch for that also.So
>>>>>> instead of that limiting it to just state is a good idea.
>>>>>>>> code.
>>>>>>>
>>>>>>> Agreed. If we  agree on the above structure, I can modify the
>>>>>>> charging subsystem patch to use the same structure.
>>>>>>> (https://lkml.org/lkml/2012/10/18/219). This would give a
>>>>>>> reference for the
>>>>>> new feature.
>>>>>>>
>>>>>>>>
>>>>>>>> You explained following changed state of USB according to Host
>>>>>>>> state on other patch.
>>>>>>>> ---------------------------
>>>>>>>> For USB2.0
>>>>>>>> 1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
>>>>>>>> 2) CONNECT (100mA)->UPDATE(500mA)->HOST
>>>>>> SUSPEND(2.5mA/500mA)-
>>>>>>>>> DISCONNECT(0mA)
>>>>>>>> 3) CONNECT (100mA)->UPDATE(500mA)->HOST
>>>>>> SUSPEND(2.5mA/500mA)-
>>>>>>>>> HOST RESUME(500mA)->DISCONNECT(0mA)
>>>>>>>>
>>>>>>>> For USB 3.0
>>>>>>>> 4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
>>>>>>>> 5) CONNECT (150mA)->UPDATE(900mA)-> HOST
>>>>>> SUSPEND(2.5mA/900mA)-
>>>>>>>>> DISCONNECT(0mA)
>>>>>>>> 6) CONNECT (100mA)->UPDATE(900mA)->HOST
>>>>>> SUSPEND(2.5mA/900mA)-
>>>>>>>>> HOST RESUME(900mA)->DISCONNECT(0mA)
>>>>>>>> ---------------------------
>>>>>>>>
>>>>>>>> I have a question. Can the provider device driver(e.g.,
>>>>>>>> extcon-max77693.c/
>>>>>>>> extcon-max8997.c) detect the changed state of host? I'd like to
>>>>>>>> see the example device driver that the provider device driver
>>>>>>>> detect changed state of host.
>>>>>>>> Could you provide example device driver?
>>>>>>>
>>>>>>> Good question. The OTG drivers are capable of identifying the
>>>>>>> SUSPEND
>>>>>> event.
>>>>>>> System cannot setup SDP (USB host) charging with maximum charging
>>>>>>> current - 500mA (USB2.0/ 900mA(USB 3)) without enumerating the
>> USB.
>>>>>>> The USB enumeration can be done only with a USB/OTG driver. IMHO
>>>>>>> the above extcon drivers (extcon-max77693.c/ extcon-max8997.c) are
>>>>>>> not capable of doing the USB enumeration and identifying the
>>>>>>> charge current. They can just identify the charger type -
>>>> SDP/DCP/CDP/ACA/AC.
>>>>>>> The intelligence for USB enumeration should be inside USB/OTG
>> driver.
>>
> 
