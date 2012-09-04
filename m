Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2IDTrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:47:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63503 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757690Ab2IDTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbVe77pAYdOw0+_2G2FWVWcn4GKQty6R-LXXEz-OkUdUg@mail.gmail.com>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
	<1345720529-32315-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdbVe77pAYdOw0+_2G2FWVWcn4GKQty6R-LXXEz-OkUdUg@mail.gmail.com>
Date: Wed, 5 Sep 2012 01:17:48 +0530
Message-ID: <CAJuYYwTD+vMg=YjUj4G0E-uakk=Y_SD+cUU22QSx0yRC50V75w@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        dong.aisheng@linaro.org, swarren@wwwdotorg.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 September 2012 16:44, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Aug 23, 2012 at 1:15 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> Add a new device tree enabled pinctrl and gpiolib driver for Samsung
>> SoC's. This driver provides a common and extensible framework for all
>> Samsung SoC's to interface with the pinctrl and gpiolib subsystems. This
>> driver supports only device tree based instantiation and hence can be
>> used only on those Samsung platforms that have device tree enabled.
>>
>> This driver is split into two parts: the pinctrl interface and the gpiolib
>> interface. The pinctrl interface registers pinctrl devices with the pinctrl
>> subsystem and gpiolib interface registers gpio chips with the gpiolib
>> subsystem. The information about the pins, pin groups, pin functions and
>> gpio chips, which are SoC specific, are parsed from device tree node.
>>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>
> Looks good to me, I saw Stephen had some minor comments and
> I expect that you probably fix them before applying to the Samsung
> tree so:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Feel free to push this through ARM SoC, I guess that's the plan?

Hi Linus,

Thanks for reviewing the Samsung pinctrl driver patches. I will do the
changes that Stephen has listed and resubmit. I will request Samsung
maintainer to consider the support for pinctrl driver for 3.7.

Thanks,
Thomas.
