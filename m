Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2GRFnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:43:07 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:51343 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677Ab2GRFnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:43:01 -0400
MIME-Version: 1.0
In-Reply-To: <50055C38.3000309@mvista.com>
References: <1342448023-14438-1-git-send-email-kishon@ti.com>
	<1342448023-14438-3-git-send-email-kishon@ti.com>
	<50055C38.3000309@mvista.com>
Date: Wed, 18 Jul 2012 11:13:00 +0530
Message-ID: <CAAe_U6KGPnTefBVzYises6-+o40MZTr8j+zLRB504TDOfmsf9A@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm/dts: omap4: Add ocp2scp data
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 17, 2012 at 6:06 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 16-07-2012 18:13, Kishon Vijay Abraham I wrote:
>
>> Add ocp2scp data node in omap4 device tree file.
>
>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
>>   1 files changed, 8 insertions(+), 0 deletions(-)
>
>
>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>> index 359c497..bda5df3 100644
>> --- a/arch/arm/boot/dts/omap4.dtsi
>> +++ b/arch/arm/boot/dts/omap4.dtsi
>> @@ -272,5 +272,13 @@
>>                         ti,hwmods = "mmc5";
>>                         ti,needs-special-reset;
>>                 };
>> +
>> +               ocp2scp@4a0ad000  {
>
>
>    "reg" property is absent, so why do you give the node name an address
> postfix?
When I was initially developing, I had "reg" property populated. Those
info is now obtained from *ti,hwmods*. I'll resend the patch removing
it.

Thanks
Kishon
