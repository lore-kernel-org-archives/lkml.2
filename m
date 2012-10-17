Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2JQHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:08:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32871 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2JQHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:08:36 -0400
X-AuditID: cbfee60f-b7f656d000001a3b-ad-507e59720bbe
Date: Wed, 17 Oct 2012 07:08:34 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH] extcon : callback function to read cable property
To: "Tc, Jenny" <jenny.tc@intel.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121017064404433@myungjoo.ham
Msgkey: 20121017064404433@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121017064404433@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18312556.138071350457714044.JavaMail.weblogic@epml24>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zHd2iyLoAg1dLDC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrMff2AqWyVS8vv+CuYHxiHQXIyeHkIC6xKIlJ9lAbAkBE4lF
	i3rZIWwxiQv31gPFuYBqljFKbLg9nRGm6ObfFlaIxHxGiVtrVoB1sAioSqycs4+li5GDg01A
	T2Lm52SQsLCAl8TRrm+sILaIQKLE+U9bmUFsZoECiaOffrNAHKEksWbfKzCbV0BQ4uTMJywQ
	u1Ql9l9+xQ4RV5O4c20jE0RcQmLW9AusEDavxIz2p1D1chLTvq5hhrClJc7P2sAI88zi74+h
	4vwSx27vYAI5E6T3yf1gmDG7N3+BhoOAxNQzB6FatSS6ezZBreWTWLPwLQvMmF2nljPD9N7f
	MpcJ4i1FiSndD9khbC2JLz/2saF7i1fASeLl0g6mCYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJ
	BcVJ6ammesWJucWleel6yfm5mxghaYF/B+OiBotDjAIcjEo8vAFLawOEWBPLiitzDzFKcDAr
	ifCaNwKFeFMSK6tSi/Lji0pzUosPMfoA428is5Rocj4wZeWVxBsaGxgbGloamplamhrgEFYS
	5y3zSAkQEkhPLEnNTk0tSC2CGcfEwSnVwChoxBusfCK3yODHlPrmDebLtukKZ654MImroF2V
	YUNZjVixxarX9602mjD6uFXmCFy802Cw+d0z7juTzcze/Vz37NnXZ3w53j7Xkh3m+VZwPj3V
	7d5/Ru6dyPSP/C8C0/vPFrb+C+y4Vcqx+n1CgoWzfPDp+pCEFcLdXyYxZE7qYS7l2PmsVYml
	OCPRUIu5qDgRAO9u/KU4AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/tmbpFkXUBBu9361pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jFmPv7EVLJOpeH3/BXMD4xHpLkZODiEBdYlFS06ygdgSAiYSN/+2sELYYhIX7q0HinMB1cxn
	lLi1ZgU7SIJFQFVi5Zx9LF2MHBxsAnoSMz8ng4SFBbwkjnZ9A+sVEUiUOP9pKzOIzSxQIHH0
	028WiF1KEmv2vQKzeQUEJU7OfMICsUtVYv/lV+wQcTWJO9c2MkHEJSRmTb8AdQ+vxIz2p1D1
	chLTvq5hhrClJc7P2sAIc/Pi74+h4vwSx27vYAI5E6T3yf1gmDG7N3+BeldAYuqZg1CtWhLd
	PZug1vJJrFn4lgVmzK5Ty5lheu9vmcsE8ZaixJTuh+wQtpbElx/72NC9xSvgJPFyaQfTBEa5
	WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FRTveLE3OLSvHS95PzcTYzgBPWMfwfjogaLQ4wC
	HIxKPLwBS2sDhFgTy4orcw8xSnAwK4nwmjcChXhTEiurUovy44tKc1KLDzH6AONvIrOUaHI+
	MHnmlcQbGhsYGxpamhuYGhpZ4BBWEuct80gJEBJITyxJzU5NLUgtghnHxMEp1cD4sP907KYv
	bF8/s3K/LDU6c2utpo2h/rUTDysXXlU5pGl7yj5AMWnJ7e1XGITnTrzdf+mJ1xzPzdtEcvKu
	S5ndL03qay37LDzrquqTqgqH1Ux7JGNfML4vy7gfdyL5ydOs6XLT5K6UvLveP/uI9M9lc7qb
	TF3llBXfMOUnyfjpq0gs+heSsSdXiaU4I9FQi7moOBEAMWgVLH0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9H78i8x002509

> Myunjoo/Chanwoo
> 
> Ping...
> Could you please review this patch?
> 
> -jtc
> 
> > > > Subject: Re: [PATCH] extcon : callback function to read cable
> > > > property
> > > >
> > > > I think the reason why we have extcon is in first place is to only
> > > > notify the clients of cable connection and disconnection and it is
> > > > up to the client to decide what else to do with the cable such as
> > > > finding which state it is in and other details.
> > > > So I feel this should not be handled in the extcon.
> > > >
> > > > However it is up to the maintainer to decide.
> > >
> > > Once the consumer gets the notification, it needs to take some action.
> > > One of the action is to read the cable properties. This can be done by
> > > proprietary calls which is known both to the consumer and the provider.
> > > My intention is to avoid this proprietary calls. Since both the
> > > provider and consumer are communicating with the extcon subsystem , I
> > > feel having a callback function of this kind would help to avoid the
> > > use of proprietary calls. Also I agree that extcon notifier chains are
> > > used to notify the cable state (attach/detach). But if a cable has
> > > more than two states (like the charger cable) how do we support it without
> > having a callback function like this?
> > > Let the maintainer take the final decision.
> > Well this use case will keep on growing if we start factor in this kind of
> > changes and that is why I am opposed to adding any other state.
> > Maintainer?
> > >
> > >
> > 

Hello,


I don't think it's appropriate to declare the charger specific
properties in extcon.h. The status of a charger should be and can be
represented by an instance of regulator, power-supply-class,
or charger-manager.

Thus, we may (I'm still not sure) need to let extcon to relay
the instance (struct device? or char *devname?) with some callback
similar with get_cable_device().  However, allowing (and encouraging)
to pass void pointer of cable_props to extcon users from extcon device
appears not adequete. If the both parties can use their own "private"
data structure, why they cannot simply pass their own data witht the
"private" data channel?
 

Recap:
- The later part of patch: NACK
- The first part of patch (callback): need to reconsider the data type.
We may get device pointer or device name that is correspondant to the
cable, which in turn, guides us to the corresponding data structure
(charger-manager, regulator, or something) However, I'm still not sure
which should be appropriate for this.


Cheers!
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
