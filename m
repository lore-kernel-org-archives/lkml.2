Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2AaPAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:00:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2AaPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:00:05 -0500
Message-ID: <4F2801EB.9040405@samsung.com>
Date: Tue, 31 Jan 2012 23:59:55 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Greg KH'" <gregkh@suse.de>
Subject: Re: [PATCH] serial: samsung: Add support serial for EXYNOS4212 and
 EXYNOS4412
References: <042101ccdfe1$11ec0d60$35c42820$%kim@samsung.com> <4F278C02.7040008@gmail.com>
In-Reply-To: <4F278C02.7040008@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/12 15:36, Namhyung Kim wrote:
> Hello,
>
> 2012-01-31 3:25 PM, Kukjin Kim wrote:
>> Kukjin Kim wrote:
>>>
>>>
>>> This should be added for EXYNOS4212 and EXYNOS4412 SoCs.
>>>
>>> Cc: Thomas Abraham<thomas.abraham@linaro.org>
>>> Cc: Greg Kroah-Hartman<gregkh@suse.de>
>>> Cc: stable@kerne.org
>>
>> Oops, should be 'Cc: stable@kernel.org'
>>
>
> No, it should be 'Cc: stable@vger.kernel.org' :)
> Please see below:
>
> https://lkml.org/lkml/2012/1/9/418
>
Thanks for your pointing out.

I thought, seems there were discussions about this and I thought again 
the result is that we should use 'Cc: stabel@kernel.org' instead of 'Cc: 
stable@vger.kernel.org'...

And according to the url, simply 'Cc: stable <stable@vger.kernel.org>'?

Anyway, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
