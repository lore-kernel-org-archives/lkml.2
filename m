Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757Ab2JYIhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:37:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56442 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933834Ab2JYIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:37:09 -0400
X-AuditID: cbfee60e-b7f6c6d000007f11-71-5088fa325e8a
Date: Thu, 25 Oct 2012 08:37:06 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH] extcon : callback function to read cable property
To: "Tc, Jenny" <jenny.tc@intel.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121025083656667@myungjoo.ham
Msgkey: 20121025083656667@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121025083656667@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16192195.128621351154225389.JavaMail.weblogic@epml11>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zPV2jXx0BBvtu8lhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDTcbmQumaVfcWHOCrYGxRauLkZNDSEBdYtGSk2wgtoSAicSW
	iUcYIWwxiQv31gPFuYBqljFKXN86gQWmaOOBJnaIxHxGiVMXG5lBEiwCqhI9d9qAujk42AT0
	JGZ+TgYJCwt4SRzt+sYKYosIJEqc/7QVrJxZoEDi6KffLBBHKEms2fcKzOYVEJQ4OfMJ1C5V
	iU/P1kLF1SSWv21ihYhLSMyafgHK5pWY0f4Uql5OYtrXNcwQtrTE+Vkb4J5Z/P0xVJxf4tjt
	HUwgZ4L0PrkfDDNm9+Yv0HAQkJh65iBUq5bEtf7VUDafxJqFb1lgxuw6tZwZpvf+lrlMEG8p
	SkzpfsgOYWtJfPmxjw3dW7wCThIHZpxlnMCoPAtJahaS9llI2pHVLGBkWcUomlqQXFCclJ5q
	olecmFtcmpeul5yfu4kRkhb4djDOa7A4xCjAwajEw3vQoyNAiDWxrLgy9xCjBAezkgjv9vdA
	Id6UxMqq1KL8+KLSnNTiQ4w+wPibyCwlmpwPTFl5JfGGxgbGhoaWhmamlqYGOISVxHnrPVIC
	hATSE0tSs1NTC1KLYMYxcXBKNTDKNk0PSEpX4yo5ePxKfsKcTW7Nn5lT2CUM2zw5zP5w5fYz
	/tDwWsicG6O/cN3Es1ZWz1cofFn1z8974cGNS9863wo+UHlhp0vvvugHBzgKrpdZZbRwNLJp
	WO6veLT2aqZo737bCxpn7yyYedzzSntOhwT7I67uXadTL0m92pB/fNb2A4qTgw8qsRRnJBpq
	MRcVJwIAKH68tDgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/t6bpGvzoCDFYf4rC4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GRtuNjIXTNOuuLHmBFsDY4tWFyMnh5CAusSiJSfZQGwJAROJjQea2CFsMYkL99YDxbmAauYz
	Spy62MgMkmARUJXoudPG2MXIwcEmoCcx83MySFhYwEviaNc3VhBbRCBR4vynrWDlzAIFEkc/
	/WaB2KUksWbfKzCbV0BQ4uTMJywQu1QlPj1bCxVXk1j+tokVIi4hMWv6BSibV2JG+1OoejmJ
	aV/XMEPY0hLnZ21ghLl58ffHUHF+iWO3dzCBnAnS++R+MMyY3Zu/QL0rIDH1zEGoVi2Ja/2r
	oWw+iTUL37LAjNl1ajkzTO/9LXOZIN5SlJjS/ZAdwtaS+PJjHxu6t3gFnCQOzDjLOIFRbhaS
	1Cwk7bOQtCOrWcDIsopRNLUguaA4KT3VRK84Mbe4NC9dLzk/dxMjOEE949vBOK/B4hCjAAej
	Eg/vQY+OACHWxLLiytxDjBIczEoivNvfA4V4UxIrq1KL8uOLSnNSiw8x+gDjbyKzlGhyPjB5
	5pXEGxobGBsaWpobmBoaWeAQVhLnrfdICRASSE8sSc1OTS1ILYIZx8TBKdXAmOC3MS/S5PqF
	rcYvumwcShyrXqlO4WsqTzV+sfvmH7sQsYiVUzV95+Vd/yu39bDRQzl126yjJckHSo7t2pbA
	02XONf3G7MJXdgWboi7X+iTIiqzdtWTHwqub3y/ecctRhMXunfPHRv5VXec+fjG2urNvZc3V
	+AUel/NvbzFNuWEa/rY0PKjPX4mlOCPRUIu5qDgRAOKdGjx9AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9P8bKt5016196

> 
> > Subject: Re: [PATCH] extcon : callback function to read cable property
> > 
> > On 10/19/2012 12:13 PM, Tc, Jenny wrote:
> > The rold of extcon inform only attached/detached state of extcon consumer
> > driver from extcon provider driver. After extcon consumer driver detect the
> > state of cable through extcon, extcon consumer driver or framework should
> > get the additional information of cable from other device driver except of
> > extcon.
> > 
> > Also, extcon manage various cables (e.g., USB, TA, MHL, JIG-USB-ON, JIG-
> > USB-OFF, Dock) What are common properties among many cables expect
> > attached or detached state?
> > 
> 
> For charger cable the current each cable can provide will be common.
> But may not be relevant for other cables. 
> 
> I understand your point on extcon role. But my concern is, when the consumer
> driver gets a notification on cable state change, how does the consumer query the
> cable properties in a generic way. Do you have any suggestions for this?
> 
> A use case can be as below
> 
> When a USB host cable (SDP) connected to the platform, without USB enumeration
> it can support only up to 100mA(USB2.)/150mA(USB 3.0) (As per USB charging spec).
> Once the enumeration is done this can be 500mA/950mA. If the consumer charger driver
> need to configure the charger chip, it need to know the charger cable capabilities.
> For example a platform PLAT1 may have charger driver CHRGR1 and OTG driver OTG1.
> But platform PLAT2 may have CHGR1 but different OTG driver OTG2. How 
> CHGR1 driver can detect  the cable properties without having any platform layer
> hooks? The platform layer hooks (using platform data)will work only if the consumer is
> a platform driver. What if it's a framework which will have the same flow in all platforms?

In general,
an extcon user (extcon notifee) knows who's the extcon notifier; the user
is supposed to know the name of the notifier.

Thus, the extcon user should be able to get the appropriate object; i.e.,
a regulator struct in this case. Then, according to the USB state,
the current limit of the USB can be changed by the notifier; which
may notify (regulator subsystem has one) the extcon user to react
(change current limit of charger?)

Anyway, in your case of PLAT2, doesn't CHGR1 has (or is) a regulator
controlling the charger current and if the OTG2 regulator affects
the behavior of CHGR1, (the current of OTG2-reg goes to CHGR1-reg)
the consumer-supplier chain should be setup (if the BSP is ideal).

OR

If it is impossible to have any objects of OTG2 (looks strange, but..),
you may have two cables, USB (data) and Fast-charger.04 (add +400mA to USB),
where Fast-charger.04 is enabled when USB2 enumeration is done with 5.



However, the following callback might be considered if there are cases where
an extcon user has information of extcon_name and cable_name while the user
CANNOT get any information on which device or object is related with the
specific cable; in struct extcon, with optional user initializing data section:

+	struct device **cable_device;
OR
+	char **cable_device_name;

With any relevant changes in the status with cable_device,
we may notify any notifier-block that are interested in the specific
cable. Then, the notifier-block (for register_interest) is going to
handle extcon-state changes and cable_device notifications.
Currently, the user's nb is for cable attach/detach events with
true/false value in the place of 32bit value (val). However,
if we add the third possible value for that parameter
(0: cable detached, 1: cable attached, 2: cable status changed;
go find out what's going on), it is still compatible.

I considered using a void pointer instead of cable_device, too.
However, that would spoil the subsystem too much; we'll be creating
a total chaos: "USB-A driver uses struct regulator", "USB-B driver
uses struct device", "USB-C driver uses true/false", and so on.


Cheers,
MyungJoo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
