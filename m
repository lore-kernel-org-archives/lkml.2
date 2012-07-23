Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2GWB5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:57:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64288 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab2GWB5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:57:48 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-1b-500caf9a0c40
Message-id: <500CAF8F.5040407@samsung.com>
Date: Mon, 23 Jul 2012 10:57:35 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 0/6] mmc: dw_mmc: add support for device tree based
 instantiation
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
 <5008279B.4000001@samsung.com>
 <CAJuYYwQBgpJ1wiS3fSDS2cMi6kanuO47rc8SmniAqjRPuBGJHg@mail.gmail.com>
 <195201cd6600$7cb089f0$76119dd0$%kim@samsung.com>
In-reply-to: <195201cd6600$7cb089f0$76119dd0$%kim@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd1Z63kCDF41SVpc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbF+fX3BAe6KDxN+MTcwzuTsYuTkkBAwkfi6
	fyULhC0mceHeerYuRi4OIYFFjBKLvv5kBkkICbxklOhryAGxeQW0JK6v2A4WZxFQldi9rw3M
	ZhPQkdj+7TgTiC0qECbx6u5PNoh6QYkfk++BLRARUJPoWbyVEWQBs8BjJok155awgiSEBaIk
	Znf3sEAse8ooce90FIjNKWAn8f5gM9ggZqAF+1unQdnyEpvXvGWewCgwC8mOWUjKZiEpW8DI
	vIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCifSe9gXNVgcYhRgINRiYf3YTlPgBBrYllx
	Ze4hRgkOZiUR3svXuQOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ85p4f/UXEkhPLEnNTk0tSC2C
	yTJxcEo1MEpdjzr0Zf3hfbKsSscyz7leZNnj0jFRsiQ9osxY8x8/d6hlIfPZh9dbnlYo/P3R
	k+UXFV6/LnX3JWbBwhOPdj9NKg1/eSvz7/0nYrr65zs3beO13Xl8xrk468xLe2sCtD41vuGX
	/VYbGShxZ/o9+7M8TBLfpO4oTbSLuTnngSrPLduZ/Rf/1CmxFGckGmoxFxUnAgAJjlPjRgIA	AA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 07:47 AM, Kukjin Kim wrote:
> Thomas Abraham wrote:
>>
>> On 19 July 2012 20:58, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi Thomas,
>>>
>>> I think not good that added the samsung specific code into dw_mmc-
>> pltfm.c
>>> How about separating to dw-mmc-exynos.c?
>>
>> I am not sure of this. The only samsung specific code in
>> dw_mmc-pltfm.c file is the data for of_device_id instances. The clock
>> lookup added into this file in the 3rd patch does not cause any harm
>> on non-samsung SoC's which might not define those clocks (on clock
>> lookup failure, there are only warning printed, the driver's probe
>> does not fail.
>>
> I agree with Thomas' opinion, in addition, the dw_mmc-pltfm.c file can
> support that, so adding dw-mmc-exynos.c is not needed now.
> 
>> I would prefer not to add separate file for Exynos SoC's for now.
>> Splitting into different files will need to defined new callbacks
>> which I fell is not really required.
Then where is the callback function located?

Best Regards,
Jaehoon Chung
>>
> Yes.
> 
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


