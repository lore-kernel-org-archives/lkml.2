Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2GJGzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:55:18 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:33534 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab2GJGzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <4FFBC808.5050602@ti.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
	<1340884267-28908-9-git-send-email-kishon@ti.com>
	<4FFBC808.5050602@ti.com>
Date: Tue, 10 Jul 2012 12:25:13 +0530
Message-ID: <CAAe_U6JE6XoNm85zcS6c=EbbXy=c0=gzTda6sChr8VSjNM+utw@mail.gmail.com>
Subject: Re: [PATCH v1 08/11] arm/dts: Add twl4030-usb data
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 10, 2012 at 11:43 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
>>
>> Add twl4030-usb data node in twl4030 device tree file.
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
>>   1 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/twl4030.dtsi
>> b/arch/arm/boot/dts/twl4030.dtsi
>> index 22f4d13..66534a3 100644
>> --- a/arch/arm/boot/dts/twl4030.dtsi
>> +++ b/arch/arm/boot/dts/twl4030.dtsi
>> @@ -37,6 +37,18 @@
>>                 regulator-max-microvolt =<3150000>;
>>         };
>>
>> +       vusb1v5: regulator@3 {
>> +               compatible = "ti,twl4030-vusb1v5";
>> +       };
>
>
> These @3, @4 are actually wrong since the node do
> not have a 'reg' property in it. This was commented on
> by David Brown on my original series which added this but
> it somehow slipped through the cracks. I understand that
> you would have looked up what existed in the file and
> extended, but what already exists in the file needs to
> be fixed up too. I'll send in a patch to fix those up.

Ok. i'll follow suit :-)

Thanks
Kishon
