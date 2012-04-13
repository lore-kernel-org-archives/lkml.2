Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555Ab2DMJaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:30:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab2DMJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:30:20 -0400
Date: Fri, 13 Apr 2012 11:30:50 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v3 0/3] i2c-s3c2410: Updates for exynos4210 and DT-based
 systems
In-reply-to: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>, w.sang@pengutronix.de
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Message-id: <4F87F24A.1040408@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.03.2012 20:11, Karol Lewandowski wrote:

> Changes since v2:
>  - Merge device type and flags into flat bitmask named quirks -
>    Consequently, treat s3c24xx as baseline hardware platform and
>    support all hw variations via quirks [Suggested by Mark Brown]
> 
> Changes since v1:
>  - Move unrelated code fragment to separate patch (of_match_ptr())
>    [Suggested by Thomas Abraham]
>  - Move device-type handling to separate function and rework its
>    internals a bit [likewise]
> 
> This patchset reworks i2c-s3c2410 driver a bit to better handle
> device tree-enabled platforms and adds two quirks required by
> exynos4210-specific I2C controller used by s5p-hdmi driver.
> 
> This patchset is based on "i2c-bjdooks/for-34/i2c/i2c-samsung" branch
> taken from:
> 
>   git://git.fluff.org/bjdooks/linux.git
> 
> Karol Lewandowski (3):
>   i2c-s3c2410: Drop unused define
>   i2c-s3c2410: Rework device type handling
>   i2c-s3c2410: Add HDMIPHY quirk for S3C2440
> 
>  .../devicetree/bindings/i2c/samsung-i2c.txt        |   11 ++-
>  drivers/i2c/busses/i2c-s3c2410.c                   |   86 +++++++++++++------
>  2 files changed, 68 insertions(+), 29 deletions(-)


Wolfram,

Is there anything I can do to have these patches in -next
(and, consequently, in 3.5-rc1)?

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
