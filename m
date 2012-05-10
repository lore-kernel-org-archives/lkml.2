Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab2EJKoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:44:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63530 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2EJKoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J98Y9s6-xYH2A7-YHx--0yLrcexBsQARySdBTc3gow_yVg@mail.gmail.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
	<CAAG0J98Y9s6-xYH2A7-YHx--0yLrcexBsQARySdBTc3gow_yVg@mail.gmail.com>
Date: Thu, 10 May 2012 16:14:15 +0530
Message-ID: <CAJuYYwRpzBwTA2WkOgrnCtUFUwms4=eKjMOrOXQ9_uGiz80a3A@mail.gmail.com>
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: James Hogan <james@albanarts.com>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2012 16:02, James Hogan <james@albanarts.com> wrote:
> Hi
>
> On 2 May 2012 06:07, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Add device tree based discovery support.
>>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |   85 +++++++++
>>  drivers/mmc/host/dw_mmc-pltfm.c                    |   24 +++
>>  drivers/mmc/host/dw_mmc.c                          |  181 +++++++++++++++++++-
>>  drivers/mmc/host/dw_mmc.h                          |   10 +
>>  include/linux/mmc/dw_mmc.h                         |    2 +
>>  5 files changed, 296 insertions(+), 6 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> new file mode 100644
>> index 0000000..c1ed70e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>> @@ -0,0 +1,85 @@
>> +* Synopsis Designware Mobile Storage Host Controller
>> +
>> +The Synopsis designware mobile storage host controller is used to interface
>> +a SoC with storage medium such as eMMC or SD/MMC cards.
>> +
>> +Required Properties:
>> +
>> +* compatible: should be one of the following
>> +       - synopsis,dw-mshc: for controllers compliant with synopsis dw-mshc.
>
> Note that although undocumented in
> Documentation/devicetree/bindings/vendor-prefixes.txt (which it
> probably should be), the designware uart already uses a different
> prefix:
> { .compatible = "snps,dw-apb-uart" },
> http://lxr.linux.no/#linux+v3.3.5/drivers/tty/serial/8250/8250_dw.c#L165

Thanks James for pointing this out. I will change the prefix for mshc
controller bindings to be consistent with that of the uart controller.

Thanks,
Thomas.

>
> Cheers
> James
