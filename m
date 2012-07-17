Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2GQKVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:21:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46834 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GQKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <87liikjpw0.fsf@octavius.laptop.org>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
	<1342097668-25243-6-git-send-email-thomas.abraham@linaro.org>
	<87liikjpw0.fsf@octavius.laptop.org>
Date: Tue, 17 Jul 2012 15:51:21 +0530
Message-ID: <CAJuYYwRzAB0eUm5xV1PiB01wKXJq2efYJPczgw0EAangQLNEew@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mmc: dw_mmc: add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2012 09:53, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Thu, Jul 12 2012, Thomas Abraham wrote:
>> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> new file mode 100644
>> index 0000000..3acd6c9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> @@ -0,0 +1,108 @@
>> +* Synopsis Designware Mobile Storage Host Controller
>> +
>> +The Synopsis designware mobile storage host controller is used to interface
>> +a SoC with storage medium such as eMMC or SD/MMC cards.
>> +
>> +Required Properties:
>> +
>> +* compatible: should be one of the following
>> +     - snps,dw-mshc: for controllers compliant with synopsis dw-mshc.
>> +
>> +* reg: physical base address of the dw-mshc controller and size of its memory
>> +  region.
>> +
>> +* interrupts: interrupt specifier for the controller. The format and value of
>> +  the interrupt specifier depends on the interrupt parent for the controller.
>
> Please instead add:
>
> This file documents differences between the core properties described
> by mmc.txt and the properties used by the dw_mmc driver.
>
> mmc.txt already describes compatible, reg, interrupts, bus-width,
> cd-gpios, and wp-gpios, so you don't need to describe those again.

Ok. I will change it.

>
>> +     cnt = sizeof(of_quriks) / sizeof(struct dw_mci_of_quirks);
>> +     for (idx = 0; idx < cnt; idx++)
>> +             if (of_get_property(np, of_quriks[idx].quirk, NULL))
>> +                     pdata->quirks |= of_quriks[idx].id;
>
> of_quirks, not of_quriks.

Yes, thanks for pointing this out. I will fix this.

Thanks,
Thomas.
