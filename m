Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab1FVDnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:43:45 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54125 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab1FVDno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:43:44 -0400
Message-ID: <4E0164E8.8060708@linaro.org>
Date: Wed, 22 Jun 2011 09:13:36 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: myungjoo.ham@gmail.com
CC: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>	<1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>	<1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>	<4E002D18.2080401@linaro.org> <BANLkTi=pv=y+1XC5bYEHgL1sy48JPztiOg@mail.gmail.com>
In-Reply-To: <BANLkTi=pv=y+1XC5bYEHgL1sy48JPztiOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 08:01 AM, MyungJoo Ham wrote:
> On Tue, Jun 21, 2011 at 2:33 PM, Tushar Behera<tushar.behera@linaro.org>  wrote:
>> On Tuesday 21 June 2011 07:37 AM, MyungJoo Ham wrote:
>>>
>>> Signed-off-by: MyungJoo Ham<myungjoo.ham@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>
>>> --
>>> Changes from v1. Thanks so much for your valuable comments, Mark.
>>> - Removed unnecessary initialization data
>>> - Add __initdata where necessary
>>> - Corrected a regulator name for ADC
>>> ---
>>>   arch/arm/mach-exynos4/mach-nuri.c |  622
>>> ++++++++++++++++++++++++++++++++++++-
>>>   1 files changed, 621 insertions(+), 1 deletions(-)
>>>
>> Will it be possible to move PMIC specific defines to a common file and make
>> appropriate calls in the board-specific file?
>>
>> In that way, we can re-use this PMIC code on some other boards (e.g.
>> Insignal low-cost board Origen featuring Exynos4210 also features MAX8997).
>>
>
> Yes, we have tried creating PMIC defines at a seperated file in our
> local repositories (still doing so in those repositories).
> However, that ended up creating multiple PMIC defines (one PMIC define
> file for each board); the connections between LDO# and devices are
> different.
>
In that case, we can first post the Origen board support and PMIC code 
on the ML, then we would see if we can consolidate.

That looks more logical as per Mark's suggestion also.
>>
>> --
>> Tushar Behera
>>
>
>


-- 
Tushar Behera
