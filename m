Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2HPDUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:20:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44028 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab2HPDUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAEdQ38EW_N2Qcquyvn5UxfEc8978i4=zQE_5H65PXahQPOOEuw@mail.gmail.com>
References: <1344677543-22591-1-git-send-email-chenhc@lemote.com>
	<1344677543-22591-14-git-send-email-chenhc@lemote.com>
	<CAEdQ38EW_N2Qcquyvn5UxfEc8978i4=zQE_5H65PXahQPOOEuw@mail.gmail.com>
Date: Thu, 16 Aug 2012 11:20:47 +0800
Message-ID: <CAAhV-H7dRNiZmPDnjn-qh7GPt0kW0x1tq7GiG-reyR+xTQE41g@mail.gmail.com>
Subject: Re: [PATCH V5 13/18] drm: Define SAREA_MAX for Loongson (PageSize = 16KB).
From: Huacai Chen <chenhuacai@gmail.com>
To: Matt Turner <mattst88@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 9:58 AM, Matt Turner <mattst88@gmail.com> wrote:
> On Sat, Aug 11, 2012 at 2:32 AM, Huacai Chen <chenhuacai@gmail.com> wrote:
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao <taohl@lemote.com>
>> Signed-off-by: Hua Yan <yanh@lemote.com>
>> Cc: dri-devel@lists.freedesktop.org
>> ---
>>  include/drm/drm_sarea.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
>> index ee5389d..1d1a858 100644
>> --- a/include/drm/drm_sarea.h
>> +++ b/include/drm/drm_sarea.h
>> @@ -37,6 +37,8 @@
>>  /* SAREA area needs to be at least a page */
>>  #if defined(__alpha__)
>>  #define SAREA_MAX                       0x2000U
>> +#elif defined(__mips__)
>> +#define SAREA_MAX                       0x4000U
>>  #elif defined(__ia64__)
>>  #define SAREA_MAX                       0x10000U       /* 64kB */
>>  #else
>> --
>> 1.7.7.3
>
> SAREA is a DRI-1 concept. The Radeon drivers you're using is DRI-2, so
> what do you need this for? All the DRI-1 drivers have been removed
> from Mesa, so I think the answer is nothing.

This patch will be drop, thank you.
