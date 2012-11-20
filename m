Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2KTDpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:45:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28372 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2KTDpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:45:47 -0500
X-AuditID: cbfee60d-b7fe86d000002849-0a-50aafce9e9a9
Date: Tue, 20 Nov 2012 03:45:45 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH] extcon : callback function to read cable property
To: "Tc, Jenny" <jenny.tc@intel.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>,
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
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121120034531171@myungjoo.ham
Msgkey: 20121120034531171@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121120034531171@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31377253.278521353383144193.JavaMail.weblogic@epml19>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t8zTd2Xf1YFGPyfKmNxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyDu/dx1KwrbDiypPCBsY9eV2MnBxCAuoSi5acZOti5OCQEDCR
	mHNeDCQsISAmceHeeqAwF1DJMkaJtmM97BAJE4kfazazQ/TOZ5RYfYwXxGYRUJX4/+YRK8gc
	NgE9iZmfk0HCwgJeEke7vrGC2CICiRLnP21lBpnJLLCaVeL379OsEHOUJNbse8UCYvMKCEqc
	nPmEBWKXqsTs0wvYIOJqElf7pjBCxCUkZk2/wAph80rMaH8KVS8nMe3rGmYIW1ri/KwNjDDP
	LP7+GCrOL3Hs9g4miH95JZ7cD4YZs3vzFzYIW0Bi6pmDjBAlWhKtr/khwnwSaxa+ZYGZsuvU
	cmaY1vtb5jKB2MwCihJTuh+yQ9haEl9+7GND9xWvgJPE3WVHWScwKs9CkpqFpH0WknZkNQsY
	WVYxiqYWJBcUJ6WnGusVJ+YWl+al6yXn525ihCQE3h2McxssDjEKcDAq8fBaJq8KEGJNLCuu
	zD3EKMHBrCTC21QOFOJNSaysSi3Kjy8qzUktPsToA4y/icxSosn5wGSVVxJvaGxgbGhoaWhm
	amlqgENYSZxXsWJ6gJBAemJJanZqakFqEcw4Jg5OqQZGzydVU5SOHdkaZX1A9fvJA/fkLHof
	eK+XPJCT904n0+nVLMYNHiZc4qbi6ieCyv6WZC4SbCi2a2vfH+5+5OOv/B3/1jGqtZofvprE
	qLZo63OvwB/Xj0x+Vf7Pzu3DWW59vV0d+VH7X5+20xI0nOb2/fTsOUxyxeqrVX8+zec4eESy
	c9JxH1s/JZbijERDLeai4kQAg6oJvzUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t/tmbov/6wKMFi3TtTi8q45bA6MHp83
	yQUwRmXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAN
	VVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKkUbGRjrGZma6BkZG+iZGMRaGRoYGJkCVSVk
	ZBzeu4+lYFthxZUnhQ2Me/K6GDk5hATUJRYtOckGYksImEj8WLOZHcIWk7hwbz0bRM18RonV
	x3hBbBYBVYn/bx6xdjFycLAJ6EnM/JwMEhYW8JI42vWNFcQWEUiUOP9pK3MXIxcHs8BqVonf
	v0+zQsxRkliz7xULiM0rIChxcuYTFohdqhKzTy9gg4irSVztm8IIEZeQmDX9AiuEzSsxo/0p
	VL2cxLSva5ghbGmJ87M2MMLcvPj7Y6g4v8Sx2zuYQO4E6X1yPxhmzO7NX6DeFZCYeuYgI0SJ
	lkTra36IMJ/EmoVvWWCm7Dq1nBmm9f6WuUwgNrOAosSU7ofsELaWxJcf+9jQfcUr4CRxd9lR
	1gmMcrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSempxnrFibnFpXnpesn5uZsYwcnpGe8OxrkN
	FocYBTgYlXh4LZNXBQixJpYVV+YeYpTgYFYS4W0qBwrxpiRWVqUW5ccXleakFh9i9AHG30Rm
	KdHkfGDizCuJNzQ2MDY0tDQ3MDU0ssAhrCTOq1gxPUBIID2xJDU7NbUgtQhmHBMHp1QDY6xP
	3foJ+xMtWKSPPf6pJHC9xe7hlbIJl+KWZS7nL7r6c17536mZVWYKFmX3Nqzh0C9nPp2S+PHR
	O9sJbYrG9v/aouI1Vx+Xfj5f9Cp/XsyRW/KWatxcE5M27dJaKcRWee9gwJT/zddUG2q/XT6n
	LPU9i+/Vv1X+y6ZWZK5QYZkm1fd7dViithJLcUaioRZzUXEiAGw4umh7AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK3jsVn019447

> > >>>>>> I think that the role of extcon subsystem notify changed
> > >>>>>> state(attached/detached) of cable to notifiee, but if you want to
> > >>>>>> add property feature of cable, you should solve ambiguous issues.
> > >>>>>>
> > >>>>>> First,
> > >>>>>> This patch only support the properties of charger cable but,
> > >>>>>> never support property of other cable. The following structure
> > >>>>>> depend on only charger cable. We can check it the following
> > structure:
> > >>>>>>   struct extcon_chrg_cbl_props {
> > >>>>>>           enum extcon_chrgr_cbl_stat cable_state;
> > >>>>>>           unsigned long mA;
> > >>>>>>   };
> > >>>>>>
> > >>>>>> I think that the patch have to support all of cables for property
> > >> feature.
> > >>>>>
> > >>>>> My suggestion is to have a structure like this
> > >>>>>
> > >>>>> struct  extcon_cablel_props {
> > >>>>>     unsigned int cable_state;
> > >>>>>             unsigned int data;
> > >>>> Why can't it be float/long/double??
> > >>>>> }
> > >>>>> Not all cables will have more than two states. If any cable has
> > >>>>> more than two states, the above structure makes it flexible to
> > >>>>> represent additional state and the data associated
> > >>>>>
> > >>>>>>
> > >>>>>> Second,
> > >>>>>> Certainly, you should define common properties of all cables and
> > >>>>>> specific properties of each cable. The properties of charger
> > >>>>>> cable should never be defined only.
> > >>>> IMHO the extcon doesn't know anything about the cable except the
> > >>>> state which is currently it is in and which also is set by the
> > >>>> provider.I am unable to understand why should extcon provide more
> > >>>> than what it knows?It should just limit itself to broadcasting the
> > >>>> cable state and exploiting it for any other information would only
> > >>>> lead to
> > >> more un-necessary code.
> > >>>> It should be same as IIO subsystem where the consumer and provider
> > >>>> knows before hand what information they are going to share and with
> > >>>> what precision and IIO core is just a way to do that.It doesn't
> > >>>> know anything beyond what is given by the provider.
> > >>>> Same is the case with driver core where individual driver sets it's
> > >>>> own private data and the driver core just gives that private data
> > >>>> back to the driver as and when it needs but parsing the private
> > >>>> data in the right way is up to the individual driver.
> > >>>>
> > >>>> I fail to understand why is not the case here.
> > >>>
> > >>> The requirement is different from the IIO case. I am trying to
> > >>> extend the Power Supply class to support charging in a generic way
> > >> (https://lkml.org/lkml/2012/10/18/219).
> > >>> The extcon consumer in this case is not a device driver. It's part
> > >>> of power
> > >> supply class driver itself.
> > >>> I am open to any solution to get the cable properties dynamically.
> > >>> Do you find a better but generic mechanism for this?
> > >>>
> > >>> I am trying to extend  extcon just because I couldn°Øt find any other
> > >>> subsystem which gives cable notifications. IMHO, it's good if we can
> > >>> avoid consumer and provider driver level dependencies just by
> > >>> extending extcon. This will ensure that the same driver will work on
> > >>> any
> > >> platform as long as it's having the dependency only on extcon.
> > >>> We shouldn't put any driver level dependency between extcon
> > consumer
> > >> and provider.
> > >>> When we do like that, the extcon consumer is expecting the similar
> > >>> implementation for the provider on all platforms. This may not be
> > >>> possible
> > >> Is there anything wrong in assuming similar implementation for all
> > >> the providers?I think the providers know what it can provide and this
> > >> may vary quite a lot.Or can we make a generic provider driver which
> > >> will encompass all the randomness in the various provider
> > >> drivers?This generic driver will get all the properties and since it
> > >> will be generice anyone can use it to know what properties to expect.This
> > will keep the extcon design intact.
> > >
> > > Maintainer??
> > 
> > I agreed about opinion of anish singh. The extcon provider driver provide
> > generic
> > 
> > ----
> > struct  extcon_cablel_props {
> >      unsigned int cable_state;
> >      unsigned int data;
> > }
> > ----
> > You suggested upper structure and said it is only flexible to represent
> > additional state, But, it is non-standard. What store real data on "unsigned int
> > data"? It isn't determined and flexible. That is extcon consumer driver should
> > already know type of real data or value of real data. The extcon consumer
> > driver has strong dependency on extcon provider driver. In this case, if
> > extcon provider driver can change data value of "unsigned int data", extcon
> > consumer provider have to be modified according to extcon provider driver.
> > I think it isn't correct apporach. So, I proposed that we should define
> > properties for all cables.
> 
> I couldn°Øt find properties common for all type of cables. Alternate method I can think of is
> a new driver "extcon-charger.c".  This driver will register with extcon subsystem.
> 
> The consumer and provider can use the APIs and properties exposed by this driver.  This
> way we can ensure that extcon design is intact and the additional charger cable state and
> properties can be handled by this driver. Does that make sense?

Adding another API at a device driver is something to be avoided unless it's
inevitable.

The state/status information required by a charger should be embedded in the
data structure of the charger (e.g., regulator, power-supply-class, or
charger-manager). However, we may consider bridging them via extcon anyway.

We may have:
	enum extcon_cable_type {
		EXTCON_CT_REGULATOR,
		EXTCON_CT_PSY,
		EXTCON_CT_CHARGER_CB,
		...
	};
and have the following included at struct extcon_cable:
	union {
		struct regulator *reg;
		struct power_supply *psy;
		struct charger_cable *charger_cb;
		...
	} cable data;
	enum extcon_cable_type cable_type;

Is there any problems with this approach?


If you need to embeded "current-limit" information, the regulator should be
able to provide it (current-limit regulator).
If you need to embed "suspend/resume" status information in general for a
specific cable type, you need to define corresponding data structure related
to the cable type (class) and make it connected via extcon.


> 
> > 
> > >>
> > >>> and does not seems to  be a scalable solution. IMHO, the extcon
> > >>> should provide a mechanism to retrieve the cable properties.
> > >>> Consumer drivers can use this API to get the cable properties
> > >>> without knowing the provider driver implementation. This will  make
> > >>> the extcon drivers more
> > >> scalable and reusable across multiple platforms.
> > >>>
> > >>>>>
> > >>>>> Hope above structure would be enough to represent the common
> > cable
> > >>>>> state and it's data. If a cable has more than two states, then
> > >>>>> extcon_update_state can be used to notify the consumer 1)Provider
> > >>>>> can just toggle the "state" argument to notify the consumer that
> > >>>>> cable state is changed OR
> > >>>>> 2) Add one more argument  like  extcon_update_state(struct
> > >>>>> extcon_dev *edev, u32 mask, u32 state1, u32 sate2)
> > >>>> This will cause other drivers to change such as arizona.
> > >>>>> If the state2 is set, then consumers can use
> > >>>>> get_cable_properties() to query the cable properties. State2 need
> > >>>>> to be used only if the cable need to represent more than two state
> > >>>>>
> > >>>>>>
> > >>>>>> Third,
> > >>>>>> If we finish to decide the properties for all cables, I'd like to
> > >>>>>> see a example
> > >>>> Why do we think that state and property is the only thing which the
> > >>>> consumer want to know?I am sure there would be some more
> > properties
> > >>>> which would be of some interest to consumers and there is quite a
> > >>>> possibility that in future we might get a patch for that also.So
> > >>>> instead of that limiting it to just state is a good idea.
> > >>>>>> code.
> > >>>>>
> > >>>>> Agreed. If we  agree on the above structure, I can modify the
> > >>>>> charging subsystem patch to use the same structure.
> > >>>>> (https://lkml.org/lkml/2012/10/18/219). This would give a
> > >>>>> reference for the
> > >>>> new feature.
> > >>>>>
> > >>>>>>
> > >>>>>> You explained following changed state of USB according to Host
> > >>>>>> state on other patch.
> > >>>>>> ---------------------------
> > >>>>>> For USB2.0
> > >>>>>> 1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
> > >>>>>> 2) CONNECT (100mA)->UPDATE(500mA)->HOST
> > >>>> SUSPEND(2.5mA/500mA)-
> > >>>>>>> DISCONNECT(0mA)
> > >>>>>> 3) CONNECT (100mA)->UPDATE(500mA)->HOST
> > >>>> SUSPEND(2.5mA/500mA)-
> > >>>>>>> HOST RESUME(500mA)->DISCONNECT(0mA)
> > >>>>>>
> > >>>>>> For USB 3.0
> > >>>>>> 4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
> > >>>>>> 5) CONNECT (150mA)->UPDATE(900mA)-> HOST
> > >>>> SUSPEND(2.5mA/900mA)-
> > >>>>>>> DISCONNECT(0mA)
> > >>>>>> 6) CONNECT (100mA)->UPDATE(900mA)->HOST
> > >>>> SUSPEND(2.5mA/900mA)-
> > >>>>>>> HOST RESUME(900mA)->DISCONNECT(0mA)
> > >>>>>> ---------------------------
> > >>>>>>
> > >>>>>> I have a question. Can the provider device driver(e.g.,
> > >>>>>> extcon-max77693.c/
> > >>>>>> extcon-max8997.c) detect the changed state of host? I'd like to
> > >>>>>> see the example device driver that the provider device driver
> > >>>>>> detect changed state of host.
> > >>>>>> Could you provide example device driver?
> > >>>>>
> > >>>>> Good question. The OTG drivers are capable of identifying the
> > >>>>> SUSPEND
> > >>>> event.
> > >>>>> System cannot setup SDP (USB host) charging with maximum charging
> > >>>>> current - 500mA (USB2.0/ 900mA(USB 3)) without enumerating the
> > USB.
> > >>>>> The USB enumeration can be done only with a USB/OTG driver. IMHO
> > >>>>> the above extcon drivers (extcon-max77693.c/ extcon-max8997.c) are
> > >>>>> not capable of doing the USB enumeration and identifying the
> > >>>>> charge current. They can just identify the charger type -
> > >> SDP/DCP/CDP/ACA/AC.
> > >>>>> The intelligence for USB enumeration should be inside USB/OTG
> > driver.
> > 
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
