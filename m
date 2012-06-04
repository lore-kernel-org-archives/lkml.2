Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab2FDPwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:52:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61221 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2FDPwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNbu9E+bpt0cC8OiRhcGFe13E17bVU_ZY2EeLCzNpSavA@mail.gmail.com>
References: <1336661600-2409-1-git-send-email-emilgoode@gmail.com>
	<CAAQKjZNbu9E+bpt0cC8OiRhcGFe13E17bVU_ZY2EeLCzNpSavA@mail.gmail.com>
Date: Tue, 5 Jun 2012 00:52:48 +0900
Message-ID: <CAAQKjZMo5pWB+hVudEdTuv1h1L69n=sXTM+VCi9m3AkWPAALiQ@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Include missing linux/types.h in header
From: InKi Dae <daeinki@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emil,

we included "drm.h" with g2d driver patch instead of "<linux/types.h>
so your patch will be removed from exynos-drm-fixes. sorry for
confusing.

for this, you can refer to below link.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=include/drm/exynos_drm.h;h=b6d7ce92eadd67a67db12b19bb0d39208b870511;hp=44f79cf468d4b7baff2e5f728667475ab96f7f1e;hb=d7f1642c90ab5eb2d7c48af0581c993094f97e1a;hpb=8dcb96b628a0749184bbcc5e6c94463f89405c58

Thanks,
Inki Dae

2012/5/14 InKi Dae <daeinki@gmail.com>:
> 2012/5/10 Emil Goode <emilgoode@gmail.com>:
>> Include the linux/types.h file where used types are declared.
>>
>> Sparse gives the following warning:
>> /usr/include/drm/exynos_drm.h:92:
>>        found __[us]{8,16,32,64} type without
>>        #include <linux/types.h>
>>
>> Signed-off-by: Emil Goode <emilgoode@gmail.com>
>> ---
>>  include/drm/exynos_drm.h |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
>> index e478de4..7eb7ae7 100644
>> --- a/include/drm/exynos_drm.h
>> +++ b/include/drm/exynos_drm.h
>> @@ -29,6 +29,8 @@
>>  #ifndef _EXYNOS_DRM_H_
>>  #define _EXYNOS_DRM_H_
>>
>> +#include <linux/types.h>
>> +
>
> applied.
>
> Thanks,
> Inki Dae
>
>>  /**
>>  * User-desired buffer creation information structure.
>>  *
>> --
>> 1.7.10
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
