Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3AFXM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 18:12:28 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:54290 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3AFXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 18:12:26 -0500
Message-ID: <50EA0394.9020701@linaro.org>
Date: Mon, 07 Jan 2013 00:07:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Russ Anderson <rja@sgi.com>, linux-pm@vger.kernel.org,
        pdeschrijver@nvidia.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rja@americas.sgi.com
Subject: Re: [PATCH] cpuidle - fix lock contention in the idle path
References: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org> <20130102211314.GA29447@sgi.com> <50E6764C.9060608@linaro.org> <3077900.eue4T2ZoF8@vostro.rjw.lan>
In-Reply-To: <3077900.eue4T2ZoF8@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ ... ]

>>>> The following patch is a hot fix by returning to the initial behavior
>>>> by removing the lock when getting the driver.
>>>
>>> The patch fixes the problem.  Verified on a system with 1024 cpus.
>>> Thanks.
>>>
>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>
>>> Reported-by: Russ Anderson <rja@sgi.com>
>>> Acked-by: Russ Anderson <rja@sgi.com>
>>
>> Hi Rafael,
>>
>> could you consider this patch for merging ?
> 
> Yes, I've taken it already.
> 
> I'll include it into the next pull request.

Ok, thanks.

I noticed you rephrased the changelog. Thanks for that also.

 -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

  * English - detected
  * English
  * French

  * English
  * French

 <javascript:void(0);> <#>
