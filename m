Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2KHBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:25:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34639 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2KHBZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:25:28 -0500
X-AuditID: cbfee61b-b7f616d00000319b-36-509b0a0627ec
Message-id: <509B0A0F.5000406@samsung.com>
Date: Thu, 08 Nov 2012 10:25:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>, myunjoo.ham@gmail.com
Subject: Re: [PATCH] extcon : callback function to read cable property
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
 <1349880328.22926.2.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
 <1349963260.8329.1.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C5643BA10D@BGSMSX101.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C5643BA10D@BGSMSX101.gar.corp.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zHV02rtkBBluWGFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MTw3n2Qo2SVac/KvewPhZpIuRk0NCwETixNO37BC2mMSFe+vZ
	uhi5OIQEljFK9D+9wwxX9OAnI0RiOqPEs7VPoaq6mCT+X1/BClLFK6Al8fX5NLBRLAKqEn93
	72MCsdmA4vtf3ABq4OAQFYiQ+NXPAVEuKPFj8j0WEFtEQEViast3JpCZzAL7GCWmbJ4PtllY
	wE2i4ch3ZohlW5kktnz7CLaMUyBE4mfPUUYQm1lAXWLSvEXMELa8xOY1b5khjhCQ+Db5EAvI
	YgkBWYlNB6C+aWeXePgd6mVJiYMrbrBMYBSbheSmWUimzkIydQEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2MkJiQ3sG4qsHiEKMAB6MSD69F6swAIdbEsuLK3EOMEhzMSiK8U47MChDi
	TUmsrEotyo8vKs1JLT7E6AN07ERmKdHkfGC85pXEGxobGBsaWhqamVqaGuAQVhLnbfZICRAS
	SE8sSc1OTS1ILYIZx8TBKdXA6LHiwDmp2QHn7VXO7lyVf1DQm5dJTShdQ1ojs6uKZZ3dn5w0
	D3uPLEfm5S0Gopnz3e69ODzFo9BT6fcMS7d1n17asH8quDS/6chSR6eQSf53bzYlZPbe+Lfn
	EEfsQ8GNblztDXN1Lefvf7et7ir3/wRv+0hFzbBds34ce8p9TTvtoGza2cXxSizFGYmGWsxF
	xYkAh4hV97YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQV02rtkBBgsb9Swu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqeG82wFmyQrTv5Vb2D8
	LNLFyMkhIWAiceLBT0YIW0ziwr31bF2MXBxCAtMZJZ6tfQrldDFJ/L++ghWkildAS+Lr82ns
	IDaLgKrE3937mEBsNqD4/hc3gBo4OEQFIiR+9XNAlAtK/Jh8jwXEFhFQkZja8p0JZCazwD5G
	iSmb5zODJIQF3CQajnxnhli2lUliy7ePYMs4BUIkfvYcBTuPWUBdYtK8RcwQtrzE5jVvmScw
	CsxCsmQWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOuWfSOxhXNVgcYhTg
	YFTi4bVInRkgxJpYVlyZe4hRgoNZSYR3ypFZAUK8KYmVValF+fFFpTmpxYcYfYBBMJFZSjQ5
	H5gO8kriDY1NzIwsjcyMTcyNjXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgbHz85gt/
	QO7hB6qNp86rXlxjskhSNofh/fQ3K/dXrwgvOGe/bM6NWks/m5eBZuZ1Xr6r17Ne3W3/XUg7
	+G1P3zvP6ZZtxta/Kgy+8ny8Y704ctLsyBlPPMPM3BnXdUhqHwxxqde4yr74wcLlP6+uOjxZ
	5toS4Sk6Z3YtNWT+dnCpx3OFrXGchUosxRmJhlrMRcWJAFvAL2rmAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 03:34 PM, Tc, Jenny wrote:
>>>> Subject: Re: [PATCH] extcon : callback function to read cable
>>>> property
>>>>
>>>> I think the reason why we have extcon is in first place is to only
>>>> notify the clients of cable connection and disconnection and it is
>>>> up to the client to decide what else to do with the cable such as
>>>> finding which state it is in and other details.
>>>> So I feel this should not be handled in the extcon.
>>>>
>>>> However it is up to the maintainer to decide.
>>>
>>> Once the consumer gets the notification, it needs to take some action.
>>> One of the action is to read the cable properties. This can be done by
>>> proprietary calls which is known both to the consumer and the provider.
>>> My intention is to avoid this proprietary calls. Since both the
>>> provider and consumer are communicating with the extcon subsystem , I
>>> feel having a callback function of this kind would help to avoid the
>>> use of proprietary calls. Also I agree that extcon notifier chains are
>>> used to notify the cable state (attach/detach). But if a cable has
>>> more than two states (like the charger cable) how do we support it without
>> having a callback function like this?
>>> Let the maintainer take the final decision.
>> Well this use case will keep on growing if we start factor in this kind of
>> changes and that is why I am opposed to adding any other state.
>> Maintainer?
>>>

I think that the role of extcon subsystem notify changed state(attached/detached)
of cable to notifiee, but if you want to add property feature of cable,
you should solve ambiguous issues.

First,
This patch only support the properties of charger cable but, never
support property of other cable. The following structure depend on
only charger cable. We can check it the following structure:
	struct extcon_chrg_cbl_props {
		enum extcon_chrgr_cbl_stat cable_state;
		unsigned long mA;
	};

I think that the patch have to support all of cables for property feature.

Second,
Certainly, you should define common properties of all cables and
specific properties of each cable. The properties of charger cable
should never be defined only.

Third,
If we finish to decide the properties for all cables, I'd like to see a example code.

You explained following changed state of USB according to Host state on other patch.
---------------------------
For USB2.0
1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
2) CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)->DISCONNECT(0mA)
3) CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)->HOST RESUME(500mA)->DISCONNECT(0mA)

For USB 3.0
4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
5) CONNECT (150mA)->UPDATE(900mA)-> HOST SUSPEND(2.5mA/900mA)->DISCONNECT(0mA)
6) CONNECT (100mA)->UPDATE(900mA)->HOST SUSPEND(2.5mA/900mA)->HOST RESUME(900mA)->DISCONNECT(0mA)
---------------------------

I have a question. Can the provider device driver(e.g., extcon-max77693.c/
extcon-max8997.c) detect the changed state of host? I'd like to see the
example device driver that the provider device driver detect changed state of host.
Could you provide example device driver?

Thanks,
Chanwoo Choi
