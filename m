Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2BXNXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:23:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab2BXNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:23:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.lezcano@linaro.org designates 10.180.102.132 as permitted sender) smtp.mail=daniel.lezcano@linaro.org
Message-ID: <4F478F40.9030002@linaro.org>
Date: Fri, 24 Feb 2012 14:23:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Rickard Andersson <rickard.andersson@stericsson.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        sameo@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][V3] ux500 : decouple/recouple gic from the PRCMU
References: <1329737426-12855-1-git-send-email-daniel.lezcano@linaro.org> <4F4785D2.8070200@linaro.org> <4F478D4B.6070602@stericsson.com>
In-Reply-To: <4F478D4B.6070602@stericsson.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 02:14 PM, Rickard Andersson wrote:
> On 02/24/2012 01:42 PM, Daniel Lezcano wrote:
>> On 02/20/2012 12:30 PM, Daniel Lezcano wrote:
>>> This patch allows to decouple and recouple the gic from the PRCMU.
>>> This is needed to put the A9 core in retention mode with the cpuidle
>>> driver.
>>>
>>> It is based on top of the "DB8500 PRCMU update" patchset.
>> Hi Linus and Rickard,
>>
>> Is it possible you add your acked-by to this patch I sent to Samuel
>> Ortiz ?
>>
>> -- Daniel
>>
>>
> Hi!
>
> It is ok to me.

Thanks Rickard !

Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

