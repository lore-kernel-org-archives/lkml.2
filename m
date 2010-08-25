Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0HYIzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:55:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51687 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0HYIzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hB7iuSMrZLsNQS9yEpyRMfhg1Er8Rrn18KL6Di93gjI36Ymz+9/ukalLtghDc2dCUt
         7UU3buGPa+ACwPMEv/TBtW7syw+j4g8gQX5IAo6mUV+haO+gmfw8TZjvRWnh4hflEj02
         qz+R5ptjOxrUkIGlvfqi1wg0RLpIiIoSjj3wE=
MIME-Version: 1.0
In-Reply-To: <4C5B732D.8000301@samsung.com>
References: <4C5B732D.8000301@samsung.com>
Date: Wed, 25 Aug 2010 17:55:00 +0900
Message-ID: <AANLkTi=PxMNRunKSi9hSf95jUA1PFKYka9ASaNQgFmGV@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] MAX8998 changes for RTC
From: Joonyoung Shim <dofmind@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, a.zummo@towertech.it, p_gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/6 Joonyoung Shim <jy0922.shim@samsung.com>:
> Hi.
>
> This patchset is to support the RTC provided by the Maxim 8998 chip. For
> this first, needs i2c interface changes and interrupts support of
> max8998 mfd driver.
>
> Changes since v1:
>  - Fix missing braces of 3/3 patch from v1 review.
>  - The rest is same with v1.
>
> Changes since v2:
>  - add missing free_irq and rtc_valid_tm on rtc driver of 3/3 patch
>  - The rest is same with v2.
>
> Joonyoung Shim (3):
>      mfd: MAX8998: Use struct i2c_client to argument on i2c operation functions
>      mfd: MAX8998: Add interrupts support
>      rtc: Add MAX8998 rtc driver
>

Ping. Is there any feedback?

Thanks.

-- 
- Joonyoung Shim
