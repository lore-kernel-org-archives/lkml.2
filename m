Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2LSFtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:49:43 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43720 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2LSFte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:49:34 -0500
MIME-Version: 1.0
In-Reply-To: <50D0FD13.5060508@gmail.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
	<1355845182-14104-3-git-send-email-gautam.vivek@samsung.com>
	<50D0FD13.5060508@gmail.com>
Date: Wed, 19 Dec 2012 11:19:32 +0530
Message-ID: <CAFp+6iFr3y7+362xZ1KMkfYjJdoa5F0sWfQ+6=S11ZPwVCTDZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: Exynos5250: Enabling USB 3.0 phy for
 samsung-usbphy driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: dianders@chromium.org, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com, balbi@ti.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson.


On Wed, Dec 19, 2012 at 5:02 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 12/18/2012 04:39 PM, Vivek Gautam wrote:
>>
>> Adding base address information required for enabling
>> USB 3.0 DRD phy on exynos5250 SOC.
>>
>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos5250.dtsi |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index bbdb2c2..07b7477 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -316,7 +316,8 @@
>>
>>         usbphy@12130000 {
>>                 compatible = "samsung,exynos5250-usbphy";
>> -               reg =<0x12130000 0x100>;
>> +               reg =<0x12130000 0x100>,
>> +               <0x12100000 0x100>;
>
>
> Doesn't this second memory region mean distinct PHY controller device ?
> Why separate usbphy node can't/shouldn't be created for it ?
>
>>                 samsung,usb-phyhandle =<&phy_h0&phy_h1&phy_h2>;
>>                 samsung,enable-mask =<1>;
>>         };
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
