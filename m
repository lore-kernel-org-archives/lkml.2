Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2CLOep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:34:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58305 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2CLOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:34:43 -0400
Message-ID: <4F5E097F.1040709@gmail.com>
Date: Mon, 12 Mar 2012 07:34:39 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: dirk.brandewie@gmail.com, Karol Lewandowski <k.lewandowsk@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
References: <17763564.55121331517212251.JavaMail.weblogic@epml04>
In-Reply-To: <17763564.55121331517212251.JavaMail.weblogic@epml04>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On 03/11/2012 06:53 PM, 함명주 wrote:
> Karol Lewandowski<k.lewandowsk@samsung.com>, 2012-03-10 02:32 (GMT+09:00)
>> Dear MungJoo,
>>
>> I wasn't aware of Dirk's patchset and thus, I didn't ever try to make my
>> patches compatible with it.
>>
>> I've found hopefully correct patchset[1] via google - it's mailing list
>> posting without any feedback...  I've checked linux-next and it clearly
>> hasn't been merged.
>>
>> I'm happy to rework my patch but I would like to ask you about specific
>> tree I should base on.  Is this patchset in some subsystem-specific
>> (power?) tree? Other?
> 
> Dear Karol,
> 
> I preferred Dirk's patchset included because it is for the correctness of the device driver.
> 
> However, as Dirk's patchset has not been updated or merged for long, I guess you may go ahead trying to merge this DT patchset first.
> 

My patch set was updated on 24/1/12 and has all my changes to date.  I am not
sure why it
has not been merged Anton, David?


> It appears that this patchset does not force much trouble for Dirk's side as the two are virtually disjoint and it seems rebasing Dirk's patchset upon this patchset trivial though I didn't try that yet.
> 
Agreed, I would like to see my patches make the 3.4 though since they have been
out for a while

> Anyway, please consider "Acked-by" from me for the patches.
> 
> 
> Cheers!
> MyungJoo.
> 
>>
>> [1] https://lkml.org/lkml/2012/1/24/237
>>
>> Regards,
>> -- 
>> Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
>>
>> On 09.03.2012 01:16, 함명주 wrote:
>>
>>> Dear Karol Lewandowski,
>>>
>>> I've been confused this patchset with Dirk Brandewie's MAX17042 patchset; I though this was a follow-up version of Dirk's, which I think already acked by me.
>>>
>>> Anyway, the patches themselves look fine.
>>>
>>> However, have you checked the compatibility (mergability?) with the recent MAX17042 patches of Dirk Brandewie? I'm not sure about the merge status of Dirk's patchset, but, I think you need to consider his patches as they massively reshaped the device driver.
>>>
>>> Other than that, the patches look fine. (If that issue is already considered, regard this as an Acked-by.)
>>>
>>> Thank you.
>>>
>>>
>>> Cheers!
>>> MyungJoo.
>>>
>>> ------- Original Message -------
>>> Sender : Karol Lewandowski Junior Software Engineer/SPRC-Linux (MSD)/삼성전자
>>> Date : 2012-03-08 19:32 (GMT+09:00)
>>> Title : Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
>>>
>>> Dear MyungJoo Ham,
>>>
>>> Could you take a look at patchset I've sent? It's needed to make use of
>>> max17042 driver on device tree-enabled platforms.
>>>
>>> Regards,
>>
>>
>>
>>
>>
> 
> --
> 
> MyungJoo Ham (함명주), PHD
> 
> System S/W Lab, S/W Platform Team, Software Center
> Samsung Electronics
> Cell: +82-10-6714-2858
> 
> 
> 
> 
> 

