Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2GRFky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:40:54 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:60700 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677Ab2GRFkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <50055A21.5010206@mvista.com>
References: <1342512611-20529-1-git-send-email-kishon@ti.com>
	<1342512611-20529-3-git-send-email-kishon@ti.com>
	<50055A21.5010206@mvista.com>
Date: Wed, 18 Jul 2012 11:10:44 +0530
Message-ID: <CAAe_U6K1rXN3+YsbMo01kUUh-p=j7OBeMz-Kg_qADXjTbV2_Hg@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm/dts: omap: Add omap-usb2 dt data
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 17, 2012 at 5:57 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 17-07-2012 12:10, Kishon Vijay Abraham I wrote:
>
>> Add omap-usb2 data node in omap4 device tree file.
>
>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/omap4.dtsi |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>> index bda5df3..4d2dcc1 100644
>> --- a/arch/arm/boot/dts/omap4.dtsi
>> +++ b/arch/arm/boot/dts/omap4.dtsi
>> @@ -279,6 +279,11 @@
>>                         #size-cells = <1>;
>>                         ranges;
>>                         ti,hwmods = "ocp2scp_usb_phy";
>> +                       usb2phy@0x4a0ad080 {
>
>
>    There should be no "0x" prefix here.

Ok. Will fix it.

Thanks
Kishon
